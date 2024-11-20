`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 03:38:09 PM
// Design Name: 
// Module Name: ClockRevamp
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


module ClockRevamp(
        input logic Clk,
        input logic VGA_VS,
        input logic reset,
        input logic [7:0] keycode,
        input logic [2:0] state,
        output logic gameClk
);

logic select, select_in, ready, ready_in;
always_ff @ (posedge Clk)
    begin
        if(reset)
        begin
            select <= 0;
            ready <= 1;
        end
        else
        begin
            select <= select_in;
            ready <= ready_in;
        end

    end
always_comb
    begin
        if(keycode == 8'h2c && (ready == 1'b1))
        begin
            select_in = 1'b1;
            ready_in = 1'b0;
        end
        else if(state == 3'b010)
        begin 
        select_in = 1'b0;
            if(keycode == 8'h2c)
            begin
                ready_in = 1'b0;
            end
            else 
            begin
            ready_in = 1'b1;
            end
        end
        else 
        begin
            select_in <= select;
            if(keycode == 8'h2c)
            begin
                ready_in = 1'b0;
            end
            else 
            begin
                ready_in = 1'b1;
            end
        end
    end

always_comb
begin
    if(select)
    begin
        gameClk = Clk;
        end
    else
    begin 
        gameClk = VGA_VS;
    end
end
endmodule
