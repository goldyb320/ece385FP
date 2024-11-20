//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf     03-01-2006                           --
//                                  03-12-2007                           --
//    Translated by Joe Meng        07-07-2013                           --
//    Modified by Zuofu Cheng       08-19-2023                           --
//    Modified by Satvik Yellanki   12-17-2023                           --
//    Fall 2024 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI Lab                                --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------

/*
module  ball 
( 
    input  logic        Reset, 
    input  logic        frame_clk,
    input  logic [7:0]  keycode,

    output logic [9:0]  BallX, 
    output logic [9:0]  BallY, 
    output logic [9:0]  BallS 
);
    

	 
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=215;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=425;     // Rightmost point on the X axis,639
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=21;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=21;      // Step size on the Y axis

    logic [9:0] Ball_X_Motion;
    logic [9:0] Ball_X_Motion_next;
    logic [9:0] Ball_Y_Motion;
    logic [9:0] Ball_Y_Motion_next;

    logic [9:0] Ball_X_next;
    logic [9:0] Ball_Y_next;
    
    logic gameStart = 1'b0;
    logic oneMove = 1'b1;
    logic count = 10'd0;

    always_comb begin
        Ball_Y_Motion_next = Ball_Y_Motion; // set default motion to be same as prev clock cycle 
        Ball_X_Motion_next = Ball_X_Motion;

        case (keycode)
            8'h51: begin  // S key (Move down)
            if(gameStart == 1'b1 && oneMove == 1'b1)
            begin
                Ball_Y_Motion_next = Ball_Y_Step * 10'd3;   // Start moving down
                Ball_X_Motion_next = 10'd0;         // Stop horizontal motion
                oneMove = 1'b0;
            end
        end
            8'h50: begin  // A key (Move left)
            if(gameStart == 1'b1 && oneMove == 1'b1)
            begin
                Ball_X_Motion_next = -Ball_X_Step;  // Start moving left
                oneMove = 1'b0;
            end
        end
            8'h4F: begin  // D key (Move right)
            if(gameStart == 1'b1 && oneMove == 1'b1)
            begin
                Ball_X_Motion_next = Ball_X_Step;   // Start moving right
                oneMove = 1'b0;
            end
        end
            8'h28: begin  // Enter key (Start)
            Ball_Y_Motion_next = Ball_Y_Step;   // Start moving down
            gameStart = 1'b1;
        end
            default: begin
            if(gameStart == 1'b1)
            begin
                Ball_X_Motion_next = 10'd0;
                Ball_Y_Motion_next = Ball_Y_Step;
                oneMove = 1'b1; //allows for one move per key press
            end
            else
            begin
                Ball_X_Motion_next = 10'd0;
                Ball_Y_Motion_next = 10'd0;
            end
        end
    endcase



//        if ((BallY + BallS) >= Ball_Y_Max)  // Ball is at the bottom edge, STOP!
//        begin
//            Ball_Y_Motion_next = 0;  // set to 0 to stop all movement
//            Ball_X_Motion_next = 0;
//       end
        
    end

    assign BallS = 21;  // default ball size
    assign Ball_X_next = (BallX + Ball_X_Motion_next);
    assign Ball_Y_next = (BallY + Ball_Y_Motion_next);
   
    always_ff @(posedge frame_clk) //make sure the frame clock is instantiated correctly
    begin: Move_Ball
        if (Reset == 1'b1)
        begin 
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
			Ball_X_Motion <= 10'd0; //Ball_X_Step;
            
			BallX <= Ball_X_Center;
			BallY <= BallS + 17;
        end
        else if(keycode == 8'h28)
        begin
            BallX <= Ball_X_Center;
			BallY <= BallS + 17;
        end
        else
        begin 
	        count <= count + 1'd1;
	        if(count % 1000000000 == 0)
	        begin
	           Ball_Y_Motion <= Ball_Y_Motion_next;
	           BallY <= Ball_Y_next;  // Update ball position 
	           count <= 1'd1;
	        end
			     
			Ball_X_Motion <= Ball_X_Motion_next; 
            BallX <= Ball_X_next;		
		end  
		
		
		
		
		if ((BallX + BallS) >= Ball_X_Max)  // Ball is at the right edge
        begin
            BallX <= BallX - 10'd1;  // Border on right
        end
        else if ((BallX - BallS) <= Ball_X_Min)  // Ball is at the left edge
        begin
            BallX <= BallX + 10'd1;  // Border on left
        end
		
		
		if ((BallY + BallS) >= Ball_Y_Max)  // Ball is at the bottom edge, STOP!
        begin
            BallY <= BallY - 10'd1;// Border on bottom
            Ball_Y_Motion_next <= 0;  // set to 0 to stop all movement
            Ball_X_Motion_next <= 0;
        end
    end     
endmodule

*/

module ball 
( 
    input  logic        Reset, 
    input  logic        frame_clk,
    input  logic [7:0]  keycode,

    output logic [9:0]  BallX, 
    output logic [9:0]  BallY, 
    output logic [9:0]  BallS 
);

    parameter [9:0] Ball_X_Center = 320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center = 240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min = 215;     // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max = 425;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min = 0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max = 479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step = 21;     // Step size on the X axis
    parameter [9:0] Ball_Y_Step = 21;     // Step size on the Y axis

    logic [9:0] Ball_X_Motion;
    logic [9:0] Ball_X_Motion_next;
    logic [9:0] Ball_Y_Motion;
    logic [9:0] Ball_Y_Motion_next;

    logic [9:0] Ball_X_next;
    logic [9:0] Ball_Y_next;

    logic gameStart = 1'b0;
    logic oneMove = 1'b1;
    logic flag = 1'b1;

    logic [31:0] count;          // Larger counter for slowing movement
    logic key_pressed = 1'b0;    // Tracks if a key is currently pressed
    logic key_pressed_prev = 1'b0; // Tracks the previous key press state

    always_comb begin
        Ball_Y_Motion_next = Ball_Y_Motion; // Default no change
        Ball_X_Motion_next = Ball_X_Motion;

        key_pressed = (keycode == 8'h51 || keycode == 8'h50 || keycode == 8'h4F || keycode == 8'h28); // Detect valid keys

        case (keycode)
            8'h51: begin  // S key (Move down)
                if (gameStart == 1'b1 && oneMove == 1'b1) begin
                    Ball_Y_Motion_next = Ball_Y_Step * 10'd3; // Start moving down
                    Ball_X_Motion_next = 10'd0;               // Stop horizontal motion
                    key_pressed = 1'b1;
                end
            end
            8'h50: begin  // A key (Move left)
                if (gameStart == 1'b1 && oneMove == 1'b1) begin
                    Ball_X_Motion_next = -Ball_X_Step; // Start moving left
                    key_pressed = 1'b1;
                end
            end
            8'h4F: begin  // D key (Move right)
                if (gameStart == 1'b1 && oneMove == 1'b1) begin
                    Ball_X_Motion_next = Ball_X_Step;  // Start moving right
                    key_pressed = 1'b1;
                end
            end
            8'h28: begin  // Enter key (Start)
                Ball_Y_Motion_next = Ball_Y_Step;     // Start moving down
                gameStart = 1'b1;                     // Start the game
            end
            default: begin
                if (gameStart == 1'b1) begin
                    Ball_X_Motion_next = 10'd0;
                    Ball_Y_Motion_next = Ball_Y_Step;
                    key_pressed = 1'b0;
                end else begin
                    Ball_X_Motion_next = 10'd0;
                    Ball_Y_Motion_next = 10'd0;
                end
            end
            
        endcase
        
        if ((BallY + BallS) >= Ball_Y_Max) begin
                Ball_Y_Motion_next = 0; // Stop motion at the bottom
                Ball_X_Motion_next = 0;
            end
        
    end

    assign BallS = 21; // Default ball size
    assign Ball_X_next = (BallX + Ball_X_Motion_next);
    assign Ball_Y_next = (BallY + Ball_Y_Motion_next);

    always_ff @(posedge frame_clk) begin
        if (Reset == 1'b1) begin
            Ball_Y_Motion <= 10'd0;
            Ball_X_Motion <= 10'd0;
            BallX <= Ball_X_Center;
            BallY <= BallS + 17;
            count <= 32'd0;
            oneMove <= 1'b1;
        end
        else if(keycode == 8'h28)
        begin
            BallX <= Ball_X_Center;
			BallY <= BallS + 17;
        end else begin
            // Handle the counter for slowing the ball's fall
            count <= count + 1'd1;
            if (count >= 32'd60) begin // Adjust value for desired delay
                Ball_Y_Motion <= Ball_Y_Motion_next;
                BallY <= Ball_Y_next;
                count <= 32'd0; // Reset counter
            end

            Ball_X_Motion <= Ball_X_Motion_next;
            BallX <= Ball_X_next;

            // Boundary checks
            if ((BallX + BallS) >= Ball_X_Max) begin
                BallX <= BallX - 10'd1;
            end else if ((BallX - BallS) <= Ball_X_Min) begin
                BallX <= BallX + 10'd1;
            end

            if ((BallY + BallS) >= Ball_Y_Max) begin
                BallY <= Ball_Y_next - 10'd1;
                Ball_Y_Motion <= 1'b0;
                Ball_X_Motion <= 1'b0;
//                Ball_X_Motion_next <= 1'b0;
//                Ball_Y_Motion_next <= 1'b0;
                flag <= 1'b0;
            end

            // Detect key release (falling edge of key_pressed)
            if (key_pressed_prev && !key_pressed) begin
                oneMove <= 1'b1; // Reset oneMove on key release
            end
        end

        // Update key_pressed_prev to track previous state
        key_pressed_prev <= key_pressed;
    end
endmodule