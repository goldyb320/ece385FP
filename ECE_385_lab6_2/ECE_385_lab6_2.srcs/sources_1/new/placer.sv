`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 04:12:34 PM
// Design Name: 
// Module Name: placer
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


module placer(input logic  [9:0] rows [21:0],
				  input logic [9:0] blocks [21:0] , 
			     output logic [9:0] map_b [21:0]);
always_comb
begin
for(int i = 0; i<  22; i++)	
begin			  
map_b[i] = rows[i] | blocks[i]; 
end	
end	  
endmodule 