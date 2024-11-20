`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 03:48:24 PM
// Design Name: 
// Module Name: changeBlock
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


module changeBlock(
        input logic clk, reset,
        input logic [7:0] keycode,
        input logic [9:0] in_block [1:0],
        input logic [2:0] state,
        output logic [9:0] sblock [1:0],
        output logic swap_empty,
        output logic can_swap
);
    logic [9:0] block_reg [1:0];
    logic can_swap_in;
    logic swap_empty_in;

always_ff @(posedge clk)
    begin

    if(reset == 1'b1)
    begin
        block_reg[0] <= 10'h00;
        block_reg[1] <= 10'h00;
        can_swap_in <= 1'b1;
        swap_empty_in <= 1'b1;
    end
    else if(state == 3'b010)
    begin
        block_reg <= block_reg;
        can_swap_in <= 1'b1;
        swap_empty_in <= swap_empty_in;
    end
    else if(state == 3'b100 && keycode == 7'h06 && can_swap_in)
    begin 
        swap_empty_in <= 1'b0;
        can_swap_in <= 1'b0;
        block_reg <= in_block;
    end
    else 
    begin
        block_reg <= block_reg;
        can_swap_in <= can_swap_in;
        swap_empty_in <= swap_empty_in;
    end
end
    assign sblock = block_reg;
    assign can_swap = can_swap_in; 
    assign swap_empty = swap_empty_in;
    
endmodule 