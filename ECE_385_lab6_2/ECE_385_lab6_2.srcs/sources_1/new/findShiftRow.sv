`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 03:25:09 PM
// Design Name: 
// Module Name: findShiftRow
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


module findShiftRow(
input logic[21:0] shift,
output logic [21:0] shift_row
);

always_comb
begin 


		if(shift[0] ==1'b1)
		shift_row = 22'b1111111111111111111111;
		else if(shift[1] ==1'b1)
		shift_row = 22'b1111111111111111111110;
		else if(shift[2] ==1'b1)
		shift_row = 22'b1111111111111111111100;
		else if(shift[3] ==1'b1)
		shift_row = 22'b1111111111111111111000;
		else if(shift[4] ==1'b1)
		shift_row = 22'b1111111111111111110000;
		else if(shift[5] ==1'b1)
		shift_row = 22'b1111111111111111100000;
		else if(shift[6] ==1'b1)
		shift_row = 22'b1111111111111111000000;
		else if(shift[7] ==1'b1)
		shift_row = 22'b1111111111111110000000;
		else if(shift[8] ==1'b1)
		shift_row = 22'b1111111111111100000000;
		else if(shift[9] ==1'b1)
		shift_row = 22'b1111111111111000000000;
		else if(shift[10] ==1'b1)
		shift_row = 22'b1111111111110000000000;
		else if(shift[11] ==1'b1)
		shift_row = 22'b1111111111100000000000;
		else if(shift[12] ==1'b1)
		shift_row = 22'b1111111111000000000000;
		else if(shift[13] ==1'b1)
		shift_row = 22'b1111111110000000000000;
		else if(shift[14] ==1'b1)
		shift_row = 22'b1111111100000000000000;
		else if(shift[15] ==1'b1)
		shift_row = 22'b1111111000000000000000;
		else if(shift[16] ==1'b1)
		shift_row = 22'b1111110000000000000000;
		else if(shift[17] ==1'b1)
		shift_row = 22'b1111100000000000000000;
		else if(shift[18] ==1'b1)
		shift_row = 22'b1111000000000000000000;
		else if(shift[19] ==1'b1)
		shift_row = 22'b1110000000000000000000;
		else if(shift[20] ==1'b1)
		shift_row = 22'b1100000000000000000000;
		else if(shift[21] ==1'b1)
		shift_row = 22'b1000000000000000000000;
		else
		shift_row = 22'b0000000000000000000000;	
end
endmodule
