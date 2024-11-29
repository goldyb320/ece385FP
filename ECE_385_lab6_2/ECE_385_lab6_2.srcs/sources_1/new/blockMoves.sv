`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 04:10:56 PM
// Design Name: 
// Module Name: blockMoves
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


module blockMoves(input logic Clk,input logic reset,
							 input logic [7:0] keycode,
							 input logic [2:0] state,
							 input int centerX, centerY,
							 input logic[9:0] blocks [21:0],
							 input logic [9:0] rows [21:0],
							 output logic block_can_shift_right,
							 output logic block_can_shift_left, 
							 output logic can_rotate,
							 output logic [9:0] next_rotation [21:0]);
	int i;
		logic [9:0] rotation [21:0];
		logic [9:0] rotation_out [21:0];
	always_ff @ (posedge Clk)
		begin 
		if(reset == 1'b1)
		begin
			i <= 0;
		end
		else
		if(i>5 && keycode != 8'h00)
			i <= 1;
		else
			i++;
		
		rotation_out <= rotation;	
		end
always_comb
begin 
//increments Y when the block moves



if(i>5 && state == 3'b111)
begin
//outputs whether the block can shift right, left or rotates
can_rotate = 1'b1;
block_can_shift_right = 1'b1;
block_can_shift_left = 1'b1;							 
for(int f = 0; f < 22 ; f++)
	begin 
	if(blocks[f][9] == 1'b1)
		block_can_shift_left = 1'b0;
	if(blocks[f][0] == 1'b1)
		block_can_shift_right = 1'b0;
	if(((blocks[f]>>1) & rows[f]) != 22'h000000)
		block_can_shift_right = 1'b0;
	if(((blocks[f]<<1) & rows[f]) != 22'h000000)
		block_can_shift_left = 1'b0;
	end
end
else
begin 
block_can_shift_right = 1'b0;
block_can_shift_left = 1'b0;	
can_rotate = 1'b0;	
end

//init other map to blank
for(int g = 0; g<22; g++)
	rotation[g] = 10'h0000;


//sets the next rotation

for(int x = 0; x < 10; x++)
	for(int y = 0; y < 22; y++)
		begin
			if(blocks[y][x] == 1'b1 )
			begin 
			if(((centerY+x-centerX) > -1) && ((centerX-y+centerY) > -1) && ((centerY+x-centerX) < 22) && ((centerX-y+centerY) < 10) && (rows[centerY+x-centerX][centerX-y+centerY] != 1'b1))
				rotation[centerY+x-centerX][centerX-y+centerY] = 1'b1;
			else 
				can_rotate = 1'b0;
			end 
		end


next_rotation = rotation_out;		
end							
endmodule