//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Zuofu Cheng   08-19-2023                               --
//                                                                       --
//    Fall 2023 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI                                    --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------
	 
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*BallS, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))
       )

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 120 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
    module  color_mapper(
                    input 					startscreen, 
					input                   is_block,            // Whether current pixel belongs to ball 
                    input 					is_next_block,
					input 					is_swap_block,
					input                   is_grid,
				    input 					is_swap_grid, 
					input 					is_next_grid,       //   or background (computed in ball.sv)
					input 					is_letter,
					input 					is_start,
                    input                   [9:0] DrawX, DrawY,       // Current pixel coordinates
                    output logic            [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
);
    
    logic [7:0] Red, Green, Blue;
//	 logic [7:0] BlockR, BlockG, BlockB;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    
	 logic [4:0] block_color;
	 
	 
    // Assign color based on is_ball signal
    always_comb
    begin
	 if(startscreen == 1'b1)
	 begin
	    if(is_start)
			  begin
            // Black
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'h00;
        end
		   else
			begin
            // Background with nice color gradient
            Red = 8'h3f; 
            Green = 8'h00;
            Blue = 8'h7f;
        end
		  
	 
	 end
	 else
	 begin
		  if( is_grid == 1'b1 || is_swap_grid ==1'b1 || is_next_grid ==1'b1)
		   begin
            // Gray pieces
            Red = 8'h80;
            Green = 8'h80;
            Blue = 8'h80;
        end
        else if (is_block == 1'b1 || is_next_block == 1'b1 || is_swap_block == 1'b1 ) 
        begin
            // White pieces
            Red = 8'hFF;
            Green = 8'hFF;
            Blue = 8'hFF;
        end
		  else if(is_letter)
			  begin
            // Black
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'h00;
        end
        else 
        begin
            // Background with nice color gradient
            Red = 8'h3f; 
            Green = 8'h00;
            Blue = 8'h7f;
        end
		end
    end 
    //numlookup block (.SpriteX(DrawX), .SpriteY(DrawY),.SpriteR(BlockR), .SpriteG(BlockG), .SpriteB(BlockB));

	 
	 
endmodule
