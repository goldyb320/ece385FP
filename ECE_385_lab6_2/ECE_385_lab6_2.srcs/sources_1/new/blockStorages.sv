`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 03:29:33 PM
// Design Name: 
// Module Name: blockStorages
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


module blockStorages(
    input logic clk, reset,
				input logic [2:0] state, 
				input logic [9:0] prev, write, collision,
				//if the entire block can shift right or left
				input logic block_can_shift_right, 
				input logic block_can_shift_left,
				input logic can_rotate,
				//input from the keyboard
				input logic [7:0] keycode,
				output logic [9:0] next,
				//stop the falling and continue
				output logic Stop,
				//end the game 
				output logic endgame
		  );
//code- state 
// 000- check block (deletes full rows)
// 001- move block
// 010- write block to rows
// 011- shift down rows
// 100- add block
// 000 - endgame/HALT
logic [9:0] row;


//checks if the game should stop
assign Stop = ((collision & row) == 10'h0000) ? 1'b0:1'b1;





always_ff @ (posedge clk, posedge reset)
begin 
 
if(reset == 1'b1)
begin 
row <= 10'h0000;
//Stop <= 1'b0;
endgame <= 1'b0;
end

//checks if does nothing to a nonexistant block in the check state

else if(state== 3'b000)
begin 
	row <= row;
//	Stop <= 1'b0;
	endgame <= 1'b0;
end 
//if it collides on the next cycle, stops. Else continues falling
else if(state == 3'b001)
	//begin
	//else
	begin
	row <= prev;
//	Stop <= 1'b0;
	endgame <= 1'b0;
	end
//end


//if it is making a new block and senses a collision in the next row, ends the game and doesn't write the block
//else writes the block 

else if(state == 3'b100)
begin
if(((collision & write) != 10'h0000))
	begin 
	row <= write;
//	Stop <= 1'b0;
	endgame <= 1'b1;
	
	
	end
else
	begin 
	row <= write;
//	Stop <= 1'b0;
	endgame <= 1'b0;
	
	end 
end
//if the block is able to move left and right
else if(state == 3'b111)
begin
if((keycode == 8'h07) && block_can_shift_right== 1'b1)
	begin 
		row <= (row >> 1);
	end 
else if((keycode == 8'h04) && (block_can_shift_left ==1'b1))
	begin
		row <= (row << 1);
	end 
else if((keycode == 8'h1A) && (can_rotate ==1'b1))
		row <= 10'h000;
else 
	row <= row;

end



//if in the shift state, does nothing
else 
	begin
	row <= row; 
//	Stop <= 1'b0;
	endgame <= 1'b0;
	end

end

//outputs next to the row
assign next = row;
endmodule
