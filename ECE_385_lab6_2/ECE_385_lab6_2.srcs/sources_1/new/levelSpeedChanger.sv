`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 03:35:59 PM
// Design Name: 
// Module Name: levelSpeedChanger
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


module levelSpeedChanger(
                    input logic [7:0] keycode,
					input int level, 
				    output int speed);

							
//assign speed = (keycode == 8'h16) ? 'd10:'d51;
always_comb
    begin
        case(keycode)
//8'h2c:
//speed = 'd2;
            8'h16:
            speed = 'd4;
        default:
            speed = ('d4 > 'd51-2*level) ?  'd4 :'d51-5*level;
        endcase
    end													
endmodule 