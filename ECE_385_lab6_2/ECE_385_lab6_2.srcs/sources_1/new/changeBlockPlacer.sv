`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 04:15:06 PM
// Design Name: 
// Module Name: changeBlockPlacer
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


module changeBlockPlacer(input logic [9:0] DrawX, DrawY, 
							input logic [9:0] map [1:0], 
							output logic is_swap_block);

//blocks are 20x20
//800x520 pixels
// 40x26 blocks
// 300 -- block -- 300 x has 15 block buffer
// 40^^ block ^^ 40  y has 2 block buffer
int xindex, yindex;
assign xindex = (DrawX)/20;
assign yindex = (DrawY)/20;

always_comb
begin
//out of the playing feild for x
if(xindex < 26 || xindex > 31) 
	is_swap_block = 1'b0;
else if (yindex > 7 || yindex < 4)
	is_swap_block = 1'b0;
else
	is_swap_block = map[4+(7-yindex)][23+(10-xindex)];
end

endmodule