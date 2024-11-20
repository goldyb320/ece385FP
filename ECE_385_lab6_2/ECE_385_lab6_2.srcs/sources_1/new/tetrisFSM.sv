`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 03:19:46 PM
// Design Name: 
// Module Name: tetrisFSM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tetrisFSM(
    input logic clk, reset,
	input int speed,
	input logic [1:0] gameOver, 
	input logic [21:0] shift, stop, 
	input logic [7:0] keycode,
	input logic can_swap,
	input logic can_rotate, 
	output logic startscreen,
	output logic [2:0] out_state,
	output logic [21:0] shift_row
    );
    
    enum logic [3:0] {
	
						start, 
						check_block,
						check_block_2,
						move_block,
						write_block_to_rows,
						write_block_to_rows_2,	
						shift_down_rows,
						shift_down_rows_2,  
						add_block, 
						add_block_2,
						HALT
	
	} state, next_state; 
	int i;
	logic [21:0] shift_row_reg, shift_row_cur;
	
	//at every clock edge check if we need to reset, else update our current state to our nect state
	always_ff @ (posedge clk)
		begin 
		if(reset == 1'b1)
		begin
			state <= start;
			//shift_row_reg <= 21'h0000;
			i = 1;
		end
		else
			state <= next_state;
		
		if(state == check_block_2)
			i <= 1;
		else 
			i++;
			
		if(state == check_block_2)
			shift_row_reg <= shift_row_cur;
		else
			shift_row_reg <= shift_row_reg;
		

		end
		
		
	always_comb
	begin  
		// check_block, 
		// 	move_block, 
		// 	write_block_to_rows, 
		// 	shift_down_rows,  
		// 	add_block, 
		//				HALT
		//TODO: default values 
		case(state)
		//check keeps checking until shift is negative
		start:
			begin 
			if(keycode == 7'h28)
				next_state = check_block;
			else 
				next_state = start;
			end
		check_block:     	
			begin

			if(shift != 21'h0)
				next_state =shift_down_rows;
			else
				next_state = check_block_2; 
			end 
	 check_block_2:     	
			begin

			if(shift != 21'h0)
			begin
				next_state = shift_down_rows;
			end
			else
				next_state = add_block; 
			end
		//shift down rows unconditionally goes back to check
		shift_down_rows:
			begin 
				next_state = check_block;
				//shift_row_in <= shift_row_cur;
			end	
		shift_down_rows_2:
			begin 
				next_state = check_block; 
			end
		//write block to rows goes to move_block near unconditionally
		write_block_to_rows:
			begin
			if(gameOver != 2'h0)
				next_state = HALT; 
			else
				next_state = write_block_to_rows_2; 
			end
		write_block_to_rows_2:
			begin
			if(gameOver != 2'h0)
				next_state = HALT; 
			else
				next_state = check_block; 
			end
		//move block loops until stop signal
		move_block:
			begin
		
			//adds the right block if needed
			if(stop != 21'h0)
				next_state = write_block_to_rows;
			else if(i%speed == 0)
				next_state = move_block;
			else if((keycode == 8'h1A && can_rotate) || (keycode == 8'h06 && can_swap))
				next_state = add_block;
			else
				next_state = move_block; 
			end 
		//add block goes to move block unless the game is over			
		add_block:
			begin
			if(gameOver != 2'h0)
				next_state = HALT; 
			else
			next_state = add_block_2;
			end
		add_block_2:
			begin
			if(gameOver != 2'h0)
				next_state = HALT; 
			else
			next_state = move_block;
			end
		HALT: 
			begin
				next_state = HALT;
			end
		default: 
			next_state = check_block;
		endcase
	//deals with all the outputs
	
//code- state 
// 000- check block (deletes full rows)
// 001- move block
// 010- write block to rows
// 011- shift down rows
// 100- add block
// 000 - endgame/HALT
//TODO make shift rows logic 
		case(state)
		//check keeps checking until shift is negative
		start:
		begin
		startscreen = 1'b1;
		out_state = 3'b000;
		end
		check_block:     	
			begin
				out_state = 3'b000;
				startscreen = 1'b0;
			end 
		check_block_2:     	
			begin
				out_state = 3'b000;
				startscreen = 1'b0;
			end 
		//shift down rows unconditionally goes back to check
		shift_down_rows:
			begin 
				out_state = 3'b011;
				startscreen = 1'b0;
			end
		shift_down_rows_2:
			begin 
				out_state = 3'b011;
				startscreen = 1'b0;
			   //shift_row_reg = shift_row_cur;
			end
		//write block to rows goes to move_block near unconditionally
		write_block_to_rows:
			begin
			out_state = 3'b000;
			startscreen = 1'b0;
			end
		write_block_to_rows_2:
			begin
			out_state = 3'b010;
			startscreen = 1'b0;
			end
		//move block loops until stop signal
		move_block:
			begin
			if(i %speed == 0)
			out_state = 3'b001; 
			else
			out_state = 3'b111;
			startscreen = 1'b0;
			end 
		//add block goes to move block unless the game is over			
		add_block:
		begin
		out_state = 3'b100;
		startscreen = 1'b0;
			end
		add_block_2:
		begin
		out_state = 3'b100;
		startscreen = 1'b0;
		end
		
		HALT: 
			begin
				out_state = 3'b000;
				startscreen = 1'b0;
			end
		default: 
		begin
			out_state = 3'b000;
			startscreen = 1'b0;
			//shift_row_reg = shift_row_reg;
		end
		endcase
			

	end
assign shift_row = shift_row_reg;	
//assign startscreen = 1'b0;
findShiftRow find(.shift, .shift_row(shift_row_cur));
    
endmodule
