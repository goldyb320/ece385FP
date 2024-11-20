`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 03:43:28 PM
// Design Name: 
// Module Name: randNumGen
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


module randNumGen(
        input  clk,
        input  reset,	
        output [2:0] data
);
logic [2:0] data_in ;

always_ff @ (posedge clk)
  begin
  if (reset)
  begin 
      data_in <= 3'hf;
  end
  else begin
    data_in <= {data_in[1:0], !(data_in[2] ^ data_in[0])};
  end
end
  assign data =  (data_in == 3'b111) ? 3'b110 : data_in;
 
endmodule