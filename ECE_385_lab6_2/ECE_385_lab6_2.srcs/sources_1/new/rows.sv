`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 03:23:33 PM
// Design Name: 
// Module Name: rows
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


module rows(
                input logic clk, reset, shift_row,
				input logic [2:0] state,
				input logic [9:0] prev,write,
				output logic [9:0] next,
				output logic shift
				);
//code- state 
// 000- check block (deletes full rows)
// 001- move block
// 010- write block to rows
// 011- shift down rows
// 100- add block
// 000 - endgame/HALT
				
logic [9:0] row;

always_ff @ (posedge clk, posedge reset)
begin 

if(reset == 1'b1)
begin 
row <= 10'b0000000000;
shift <= 0;
end


//checks for a shift
else if(state == 3'b000)
begin 
//clears row and sends signal to shift
//if(shift_row == 1'b1 && row == 10'hFFFF)
//	begin
//	row <= 10'h0000;
//	shift <= 1'b0;
//	end

if(row == 10'hFFFF)
begin 
	row <= row;
	shift <= 1'b1;
end
//does nothing
else
	begin
	row <= row;
	shift <= 1'b0;
	end
end 


//writes from the map 
else if(state == 3'b010)
	begin 
	row <= write;
	shift <= 0;
	end 
//if in the shift state, and a shift is supposed to occur in the row,  takes the last value
//todo: make it shift multiple rows
//probably in state machine 
else if(state == 3'b011 && shift_row == 1'b1)
begin 
	row <= prev;
	shift <= 1'b0;
end 
//if in the move state does nothing.
//Also covers shift state where it does not shift
else
begin
shift <= 1'b0;
row <= row;
end 

end
	
assign next = row;	
endmodule
