`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 04:20:47 PM
// Design Name: 
// Module Name: startScreen
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


module startScreen(input logic [9:0] DrawX, DrawY,
							output logic is_start);
				
	
logic [10:0] letter, addr;

logic [7:0] data;

logic [2:0] xOffset;



start_lettermap lm(.DrawX, .DrawY, .letter, .xOffset,.*);
assign addr = letter;

font_rom FR(.addr, .data);	
assign is_start = data[7-xOffset];						
				
endmodule