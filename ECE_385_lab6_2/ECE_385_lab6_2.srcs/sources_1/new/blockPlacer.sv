`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 04:13:59 PM
// Design Name: 
// Module Name: blockPlacer
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


module blockPlacer(input logic [9:0] DrawX, DrawY, 
							input logic [9:0] map [21:0], 
							output logic is_block);

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
if(xindex < 15 || xindex > 25) 
	is_block = 1'b0;
else if (yindex >= 22)
	is_block = 1'b0;
else
	is_block = map[21-(yindex)][10-(xindex-15)];
end

endmodule