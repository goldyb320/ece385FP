`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 04:11:31 PM
// Design Name: 
// Module Name: trackMain
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


module trackMain(input logic Clk, reset,
input logic [7:0] keycode, 
input logic can_rotate,
input logic can_swap,
input logic [2:0] state, 
input logic block_can_shift_right, block_can_shift_left,
output int centerX,
output int centerY
);
	
	
	
	
always_ff @ (posedge Clk)
		begin 
		if(reset == 1'b1)
		begin
			centerX <= 5;
			centerY <= 20;
		end
		
		else
		begin
		//takes care of centerY
		if(state == 3'b001)
			centerY--;
		else if(keycode == 8'h1A && can_rotate)
			centerY <= centerY;	

		
		else if((state == 3'b010) || (keycode == 8'h06 && can_swap))			
			centerY <= 20;
		else 
			centerY <= centerY;			
		
		
		//takes care of the centerX
		if((state == 3'b010) || (keycode == 8'h06 && can_swap))		
			centerX <= 5;
			
		else if((keycode == 8'h07) && block_can_shift_right== 1'b1)
				centerX--;
		
		else if((keycode == 8'h04) && (block_can_shift_left ==1'b1))
			centerX++;
		
		else 
			centerX <= centerX;
		
		
		end		
end
endmodule