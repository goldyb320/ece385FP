`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 04:23:05 PM
// Design Name: 
// Module Name: selecter
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


module selecter(input logic Clk,
input logic Reset_h,
input logic [2:0] state, 
input logic [9:0] new_block [1:0],
input logic [9:0] next_block [1:0],
input logic [9:0] sblock [1:0],
input logic [9:0] next_rotation [21:0],
input logic [7:0] keycode,
input logic can_rotate,
input logic can_swap,
input logic swap_empty,

output logic [9:0] next_write [21:0]
);
logic [9:0] write [21:0];
always_ff @ (posedge Clk)
begin 
if(Reset_h)
	for(int i = 0; i<22; i++)
			write[i] = 10'h0000;
//else  if(can_rotate == 1'b1 && keycode == 8'h1A)   
// begin
// for(int i = 0; i<22; i++)
//			write[i] = next_rotation[i];
// end
//else  if(can_swap == 1'b1 && keycode == 8'h06)   
//begin 
//if(swap_empty == 1'b1)
//begin
//		write [21] = next_block[0];
//		write [20] = next_block[1];
//		for(int i = 0; i<20; i++)
//			write[i] = 10'h0000;
//end
//else 
//begin 
//		write [21] = sblock[0];
//		write [20] = sblock[1];
//		for(int i = 0; i<20; i++)
//			write[i] = 10'h0000;
//
//end
//
//end
else if(state == 3'b000)
	begin
		write [21] = new_block[0];
		write [20] = new_block[1];
		for(int i = 0; i<20; i++)
			write[i] = 10'h0000;
	end
else
	 for(int i = 0; i<22; i++)
			write[i] = write[i];

end

always_comb
begin

//	
//for(int i = 0; i<22; i++)
//			next_write[i] = 10'h0000;
next_write = write;


end

endmodule 