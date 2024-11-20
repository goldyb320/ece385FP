`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 03:52:28 PM
// Design Name: 
// Module Name: nextBlock
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
module next_Block(
input logic clk, reset,
input logic [2:0] state, 
input logic  [2:0] block, 
output logic [9:0] new_block [1:0],
output logic [9:0] next_block [1:0]
);
logic [2:0] next_num, new_num;

always_ff @ (posedge clk)
    begin 
        if(reset == 1'b1)
        begin 
            new_num = 3'h0;
            next_num = 3'h0;
        end
        if(state == 3'b010)
        begin 
            new_num = next_num;
            next_num = block;
        end
        else
        begin  
            new_num <= new_num;
            next_num <= next_num;
        end
    end 
always_comb
begin
    case (new_num)
    3'b000:
        begin 
        new_block[0] = 10'b0000100000;
        new_block[1] = 10'b0001110000;
        end
    3'b001:
        begin 
        new_block[0] = 10'b0000010000;
        new_block[1] = 10'b0001110000;
        end
    3'b010:
        begin
        new_block[0] = 10'b0001000000;
        new_block[1] = 10'b0001110000;
        end
    3'b011:
        begin
        new_block[0] = 10'b0000110000;
        new_block[1] = 10'b0001100000;
        end
    3'b100:
        begin 
        new_block[0] = 10'b0001100000;
        new_block[1] = 10'b0000110000;
        end
    3'b101:
        begin
        new_block[0] = 10'b0000110000;
        new_block[1] = 10'b0000110000;
        end
    3'b110:
        begin
        new_block[0] = 10'b0000000000;
        new_block[1] = 10'b0001111000;
        end
    default:
        begin 
        new_block[0] = 10'b0001110000;
        new_block[1] = 10'b0001110000;
        end
    endcase
case(next_num)
    3'b000:
        begin 
        next_block[0] = 10'b0000100000;
        next_block[1] = 10'b0001110000;
        end
    3'b001:
        begin 
        next_block[0] = 10'b0000010000;
        next_block[1] = 10'b0001110000;
        end
    3'b010:
        begin
        next_block[0] = 10'b0001000000;
        next_block[1] = 10'b0001110000;
        end
    3'b011:
        begin
        next_block[0] = 10'b0000110000;
        next_block[1] = 10'b0001100000;
        end
    3'b100:
        begin 
        next_block[0] = 10'b0001100000;
        next_block[1] = 10'b0000110000;
        end
    3'b101:
        begin
        next_block[0] = 10'b0000110000;
        next_block[1] = 10'b0000110000;
        end
    3'b110:
        begin
        next_block[0] = 10'b0000000000;
        next_block[1] = 10'b0001111000;
    end
    default:
    begin 
        next_block[0] = 10'b0001110000;
        next_block[1] = 10'b0001110000;
    end
endcase
end
endmodule
