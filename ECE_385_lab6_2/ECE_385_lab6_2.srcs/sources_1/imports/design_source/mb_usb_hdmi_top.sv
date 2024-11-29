//-------------------------------------------------------------------------
//    mb_usb_hdmi_top.sv                                                 --
//    Zuofu Cheng                                                        --
//    2-29-24                                                            --
//                                                                       --
//                                                                       --
//    Spring 2024 Distribution                                           --
//                                                                       --
//    For use with ECE 385 USB + HDMI                                    --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module mb_usb_hdmi_top(
    input logic Clk,
    input logic reset_rtl_0,
    
    //USB signals
    input logic [0:0] gpio_usb_int_tri_i,
    output logic gpio_usb_rst_tri_o,
    input logic usb_spi_miso,
    output logic usb_spi_mosi,
    output logic usb_spi_sclk,
    output logic usb_spi_ss,
    
    //UART
    input logic uart_rtl_0_rxd,
    output logic uart_rtl_0_txd,
    
    //HDMI
    output logic hdmi_tmds_clk_n,
    output logic hdmi_tmds_clk_p,
    output logic [2:0]hdmi_tmds_data_n,
    output logic [2:0]hdmi_tmds_data_p,
        
    //HEX displays
    output logic [7:0] hex_segA,
    output logic [3:0] hex_gridA,
    output logic [7:0] hex_segB,
    output logic [3:0] hex_gridB
);
    
    logic [31:0] keycode0_gpio, keycode1_gpio;
    logic clk_25MHz, clk_125MHz, clk, clk_100MHz;
    logic locked;
    logic [9:0] drawX, drawY, ballxsig, ballysig, ballsizesig;

    logic hsync, vsync, vde;
    logic [3:0] red, green, blue;
    logic reset_ah;
    
    assign reset_ah = reset_rtl_0;
    
    
    logic sReset, Reset_h, gameClk;
    logic [7:0] keycode;
    //legacy
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
    //current pixel being drawn
	 logic [9:0] DrawX, DrawY;
	 //tells the color mapper to draw a block or not
	 logic is_block;
	 logic is_next_block;
	 logic is_swap_block;
	 //tells the color mappper to draw the grid
	 logic is_grid;
	 logic is_next_grid;
	 logic is_swap_grid;
	 //tells the color mapper if something is a letter
	 logic is_letter;
	 logic is_start;
	 logic startscreen;
	 //rows
	 logic [9:0] rows [21:0];
	//refreshes rows
	 logic [9:0] rows_in [21:0];
     //block register
     logic [9:0] blocks [21:0];
    //block next
     logic [9:0] blocks_in [21:0];
	  //tells the blocks if they can shift right or left
	  logic block_can_shift_right;
	  logic block_can_shift_left;
	  logic can_swap;
	  logic swap_empty;
	  //tells if the block can rotate 
	  logic can_rotate;
	  //tells the next rotation
	  logic [9:0] next_rotation [21:0];
	  //keeps track of the rotation
	  int centerX, centerY;
	  //output to the screen
	 logic [9:0] map [21:0];
     //frame buffer?
     logic [9:0] map_b [21:0];
	 //output to write the piece to the two rows
	 logic [9:0] write [1:0];
	 logic [9:0] next_write [21:0];
	 //defines what/if rows are full and are giving the
	 logic [21:0] shift; 
	 //tell what rows to shift 
	 logic [21:0] shift_row;
	 //tells the piece to stop moving and to write it to the rows
     logic [21:0] stop;
     //tells the game to stop because it's donezo
     //only hooked up for the top two because they are the only ones that matter.
     logic [1:0] gameOver;
     //the state of the game (what the blocks should do)
     logic [2:0] state;	
	//the speed
		int speed; 
	//the next block
		logic [2:0] random;
	  //new blocks
	  logic [9:0] new_block [1:0];
	  logic [9:0] next_block [1:0];
	  logic [9:0] sblock [1:0];
	  
	  //score keeping stuff
	  int score, rows_cleared, level;
	  
	 always_ff @ (posedge Clk) begin 
		  	rows <= rows_in;        
            blocks <= blocks_in;
            map <= map_b;
    end
    
    //Keycode HEX drivers
    hex_driver HexA (
        .clk(Clk),
        .reset(reset_ah),
        .in({keycode0_gpio[31:28], keycode0_gpio[27:24], keycode0_gpio[23:20], keycode0_gpio[19:16]}),
        .hex_seg(hex_segA),
        .hex_grid(hex_gridA)
    );
    
    hex_driver HexB (
        .clk(Clk),
        .reset(reset_ah),
        .in({keycode0_gpio[15:12], keycode0_gpio[11:8], keycode0_gpio[7:4], keycode0_gpio[3:0]}),
        .hex_seg(hex_segB),
        .hex_grid(hex_gridB)
    );
    
    mb_block mb_block_i (
        .clk_100MHz(Clk),
        .gpio_usb_int_tri_i(gpio_usb_int_tri_i),
        .gpio_usb_keycode_0_tri_o(keycode0_gpio),
        .gpio_usb_keycode_1_tri_o(keycode1_gpio),
        .gpio_usb_rst_tri_o(gpio_usb_rst_tri_o),
        .reset_rtl_0(~reset_ah), //Block designs expect active low reset, all other modules are active high
        .uart_rtl_0_rxd(uart_rtl_0_rxd),
        .uart_rtl_0_txd(uart_rtl_0_txd),
        .usb_spi_miso(usb_spi_miso),
        .usb_spi_mosi(usb_spi_mosi),
        .usb_spi_sclk(usb_spi_sclk),
        .usb_spi_ss(usb_spi_ss)
    );
        
    //clock wizard configured with a 1x and 5x clock for HDMI
    clk_wiz_0 clk_wiz (
        .clk_out1(clk_25MHz),
        .clk_out2(clk_125MHz),
        .reset(reset_ah),
        .locked(locked),
        .clk_in1(Clk)
    );
    
    //VGA Sync signal generator
    vga_controller vga (
        .pixel_clk(clk_25MHz),
        .reset(reset_ah),
        .hs(hsync),
        .vs(vsync),
        .active_nblank(vde),
        .drawX(drawX),
        .drawY(drawY)
    );    

    //Real Digital VGA to HDMI converter
    hdmi_tx_0 vga_to_hdmi (
        //Clocking and Reset
        .pix_clk(clk_25MHz),
        .pix_clkx5(clk_125MHz),
        .pix_clk_locked(locked),
        //Reset is active LOW
        .rst(reset_ah),
        //Color and Sync Signals
        .red(red),
        .green(green),
        .blue(blue),
        .hsync(hsync),
        .vsync(vsync),
        .vde(vde),
        
        //aux Data (unused)
        .aux0_din(4'b0),
        .aux1_din(4'b0),
        .aux2_din(4'b0),
        .ade(1'b0),
        
        //Differential outputs
        .TMDS_CLK_P(hdmi_tmds_clk_p),          
        .TMDS_CLK_N(hdmi_tmds_clk_n),          
        .TMDS_DATA_P(hdmi_tmds_data_p),         
        .TMDS_DATA_N(hdmi_tmds_data_n)          
    );

  /*  
    //Ball Module
    ball ball_instance(
        .Reset(reset_ah),
        .frame_clk(vsync),                    //Figure out what this should be so that the ball will move
        .keycode(keycode0_gpio[7:0]),    //Notice: only one keycode connected to ball by default
        .BallX(ballxsig),
        .BallY(ballysig),
        .BallS(ballsizesig)
    );
    */
    
    //Color Mapper Module   
    color_mapper color_instance(
        .BallX(ballxsig),
        .BallY(ballysig),
        .DrawX(drawX),
        .DrawY(drawY),
        .Ball_size(ballsizesig),
        .Red(red),
        .Green(green),
        .Blue(blue)
    );
    
     ClockRevamp gcm(.Clk, .VGA_VS(vsync), .gameClk,.reset(sReset), .keycode, .state, .*);
	 
	 levelSpeedChanger ss(.*);
    //used VGA_VS
     tetrisFSM game(.clk(gameClk), .reset(sReset), .shift, .stop, .gameOver, .shift_row, .out_state(state), .*); 

	 randNumGen randomn(.clk(gameClk), .reset(sReset), .data(random));
	 
	 changeBlock swap(.clk(gameClk), .reset(sReset), .keycode, .in_block(new_block), .state, .sblock,.swap_empty, .can_swap);
	 
	 next_Block block(.clk(gameClk), .reset(sReset), .state, .block(random), .new_block, .next_block);
	 //use gameClk
	 blockMoves act(.Clk(gameClk), .reset(sReset), .*);
	 //use gameClk
	 trackMain center(.Clk(gameClk), .reset(sReset), .*);
	 placer mapp(.rows, .blocks, .map_b);

	 blockPlacer bmap(.DrawX, .DrawY, .map, .is_block(is_block));
	 nextBlockPlacer nbmap( .DrawX, .DrawY, .map(next_block), .is_next_block);
	 changeBlockPlacer sbmap( .DrawX, .DrawY, .map(sblock), .is_swap_block);

	 boardPlacer gmap(.DrawX, .DrawY, .is_grid);
	 nextBoardPlacer ngmap (.DrawX, .DrawY,.is_next_grid);
	 changeBoardPlacer sgmap (.DrawX, .DrawY,.is_swap_grid);
	 
	 startScreen sscreen( .*);
	 //clocked  off the gameClk 
	 //writes from the map when ws is high
	 //outputs next to its respective row
     //takes in shift_row if it is supposed to shift down
     //outputs shift if it detects a full row
	  //use gameClk
	 rows row21( .clk(gameClk), .reset(sReset), .state, .prev(10'b0) ,.write(map[21]), .next(rows_in[21]),    .shift_row(shift_row[21]) , .shift(shift[21]));
	 rows row20( .clk(gameClk), .reset(sReset), .state, .prev(rows[21]) ,.write(map[20]), .next(rows_in[20]), .shift_row(shift_row[20])  , .shift(shift[20]));
	 rows row19( .clk(gameClk), .reset(sReset), .state, .prev(rows[20]) ,.write(map[19]), .next(rows_in[19]), .shift_row(shift_row[19])  , .shift(shift[19]));
	 rows row18( .clk(gameClk), .reset(sReset), .state, .prev(rows[19]) ,.write(map[18]), .next(rows_in[18]),  .shift_row(shift_row[18])  , .shift(shift[18]));
     rows row17( .clk(gameClk), .reset(sReset), .state, .prev(rows[18]) ,.write(map[17]), .next(rows_in[17]),  .shift_row(shift_row[17])  , .shift(shift[17]));
	 rows row16( .clk(gameClk), .reset(sReset), .state, .prev(rows[17]) ,.write(map[16]), .next(rows_in[16]),  .shift_row(shift_row[16])  , .shift(shift[16]));
	 rows row15( .clk(gameClk), .reset(sReset), .state, .prev(rows[16]) ,.write(map[15]), .next(rows_in[15]),  .shift_row(shift_row[15])  , .shift(shift[15]));
	 rows row14( .clk(gameClk), .reset(sReset), .state, .prev(rows[15]) ,.write(map[14]), .next(rows_in[14]),  .shift_row(shift_row[14])  , .shift(shift[14]));
	 rows row13( .clk(gameClk), .reset(sReset), .state, .prev(rows[14]) ,.write(map[13]), .next(rows_in[13]),  .shift_row(shift_row[13])  , .shift(shift[13]));
	 rows row12( .clk(gameClk), .reset(sReset), .state, .prev(rows[13]) ,.write(map[12]), .next(rows_in[12]),  .shift_row(shift_row[12])  , .shift(shift[12])); 
	 rows row11( .clk(gameClk), .reset(sReset), .state, .prev(rows[12]) ,.write(map[11]), .next(rows_in[11]),  .shift_row(shift_row[11])  , .shift(shift[11]));
	 rows row10( .clk(gameClk), .reset(sReset), .state, .prev(rows[11]) ,.write(map[10]), .next(rows_in[10]),  .shift_row(shift_row[10])  , .shift(shift[10]));
	 rows row09( .clk(gameClk), .reset(sReset), .state, .prev(rows[10]) ,.write(map[9]), .next(rows_in[09]),   .shift_row(shift_row[9])  , .shift(shift[9]));
	 rows row08( .clk(gameClk), .reset(sReset), .state, .prev(rows[09]) ,.write(map[8]), .next(rows_in[08]),  .shift_row(shift_row[8])  , .shift(shift[8]));
     rows row07( .clk(gameClk), .reset(sReset), .state, .prev(rows[08]) ,.write(map[7]), .next(rows_in[07]),  .shift_row(shift_row[7])  , .shift(shift[7]));
	 rows row06( .clk(gameClk), .reset(sReset), .state, .prev(rows[07]) ,.write(map[6]), .next(rows_in[06]),  .shift_row(shift_row[6])  , .shift(shift[6]));
	 rows row05( .clk(gameClk), .reset(sReset), .state, .prev(rows[06]) ,.write(map[5]), .next(rows_in[05]),  .shift_row(shift_row[5])  , .shift(shift[5]));
	 rows row04( .clk(gameClk), .reset(sReset), .state, .prev(rows[05]) ,.write(map[4]), .next(rows_in[04]),  .shift_row(shift_row[4])  , .shift(shift[4]));
	 rows row03( .clk(gameClk), .reset(sReset), .state, .prev(rows[04]) ,.write(map[3]), .next(rows_in[03]),  .shift_row(shift_row[3])  , .shift(shift[3]));
	 rows row02( .clk(gameClk), .reset(sReset), .state, .prev(rows[03]) ,.write(map[2]), .next(rows_in[02]),  .shift_row(shift_row[2])  , .shift(shift[2]));
	 rows row01( .clk(gameClk), .reset(sReset), .state, .prev(rows[02]) ,.write(map[1]), .next(rows_in[01]),  .shift_row(shift_row[1])  , .shift(shift[1]));
     rows row00( .clk(gameClk), .reset(sReset), .state, .prev(rows[01]) ,.write(map[0]), .next(rows_in[00]),  .shift_row(shift_row[0])  , .shift(shift[0]));
    //write is 
	//stop stops the block from falling 
	selecter writemux(.*);
	
	
	
	blockStorages block21( .clk(gameClk), .reset(sReset), .state, .prev(10'b0),       .write(next_write[21]), .collision(rows[20]), .next(blocks_in[21]) , .Stop(stop[21]), .endgame(gameOver[0]) ,.block_can_shift_right, .block_can_shift_left, .keycode, .can_rotate );
    blockStorages block20( .clk(gameClk), .reset(sReset), .state, .prev(blocks[21]), .write(next_write[20]), .collision(rows[19]), .next(blocks_in[20]), .Stop(stop[20]), .endgame(gameOver[1]) ,.block_can_shift_right, .block_can_shift_left, .keycode, .can_rotate);
    blockStorages block19( .clk(gameClk), .reset(sReset), .state, .prev(blocks[20]), .write(next_write[19]), .collision(rows[18]), .next(blocks_in[19]), .Stop(stop[19]) ,.block_can_shift_right, .block_can_shift_left, .keycode, .can_rotate);
    blockStorages block18( .clk(gameClk), .reset(sReset), .state, .prev(blocks[19]), .write(next_write[18]), .collision(rows[17]), .next(blocks_in[18]), .Stop(stop[18]),.block_can_shift_right, .block_can_shift_left, .keycode, .can_rotate);
    blockStorages block17( .clk(gameClk), .reset(sReset), .state, .prev(blocks[18]), .write(next_write[17]), .collision(rows[16]), .next(blocks_in[17]), .Stop(stop[17]),.block_can_shift_right, .block_can_shift_left, .keycode, .can_rotate);
    blockStorages block16( .clk(gameClk), .reset(sReset), .state, .prev(blocks[17]), .write(next_write[16]), .collision(rows[15]), .next(blocks_in[16]), .Stop(stop[16]),.block_can_shift_right, .block_can_shift_left, .keycode, .can_rotate);
    blockStorages block15( .clk(gameClk), .reset(sReset), .state, .prev(blocks[16]), .write(next_write[15]), .collision(rows[14]), .next(blocks_in[15]), .Stop(stop[15]),.block_can_shift_right, .block_can_shift_left, .keycode, .can_rotate);
    blockStorages block14( .clk(gameClk), .reset(sReset), .state, .prev(blocks[15]), .write(next_write[14]), .collision(rows[13]), .next(blocks_in[14]), .Stop(stop[14]),.block_can_shift_right, .block_can_shift_left, .keycode, .can_rotate);
	blockStorages block13( .clk(gameClk), .reset(sReset), .state, .prev(blocks[14]), .write(next_write[13]), .collision(rows[12]), .next(blocks_in[13]), .Stop(stop[13]),.block_can_shift_right, .block_can_shift_left, .keycode, .can_rotate);
    blockStorages block12( .clk(gameClk), .reset(sReset), .state, .prev(blocks[13]), .write(next_write[12]), .collision(rows[11]), .next(blocks_in[12]), .Stop(stop[12]),.block_can_shift_right, .block_can_shift_left, .keycode, .can_rotate);
    blockStorages block11( .clk(gameClk), .reset(sReset), .state, .prev(blocks[12]), .write(next_write[11]), .collision(rows[10]), .next(blocks_in[11]), .Stop(stop[11]),.block_can_shift_right, .block_can_shift_left, .keycode, .can_rotate);
    blockStorages block10( .clk(gameClk), .reset(sReset), .state, .prev(blocks[11]), .write(next_write[10]), .collision(rows[9]), .next(blocks_in[10]), .Stop(stop[10]),.block_can_shift_right, .block_can_shift_left, .keycode, .can_rotate);
    blockStorages block9( .clk(gameClk), .reset(sReset), .state, .prev(blocks[10]), .write(next_write[9]), .collision(rows[8]), .next(blocks_in[9]), .Stop(stop[9]),.block_can_shift_right, .block_can_shift_left, .keycode, .can_rotate);
    blockStorages block8( .clk(gameClk), .reset(sReset), .state, .prev(blocks[9]), .write(next_write[8]), .collision(rows[7]), .next(blocks_in[8]), .Stop(stop[8]),.block_can_shift_right, .block_can_shift_left, .keycode, .can_rotate);
    blockStorages block7( .clk(gameClk), .reset(sReset), .state, .prev(blocks[8]), .write(next_write[7]), .collision(rows[6]), .next(blocks_in[7]), .Stop(stop[7]),.block_can_shift_right, .block_can_shift_left, .keycode, .can_rotate);
    blockStorages block6( .clk(gameClk), .reset(sReset), .state, .prev(blocks[7]), .write(next_write[6]), .collision(rows[5]), .next(blocks_in[6]), .Stop(stop[6]),.block_can_shift_right, .block_can_shift_left, .keycode, .can_rotate);
    blockStorages block5( .clk(gameClk), .reset(sReset), .state, .prev(blocks[6]), .write(next_write[5]), .collision(rows[4]), .next(blocks_in[5]), .Stop(stop[5]),.block_can_shift_right, .block_can_shift_left, .keycode, .can_rotate);
    blockStorages block4( .clk(gameClk), .reset(sReset), .state, .prev(blocks[5]), .write(next_write[4]), .collision(rows[3]), .next(blocks_in[4]), .Stop(stop[4]),.block_can_shift_right, .block_can_shift_left, .keycode, .can_rotate);
    blockStorages block3( .clk(gameClk), .reset(sReset), .state, .prev(blocks[4]), .write(next_write[3]), .collision(rows[2]), .next(blocks_in[3]), .Stop(stop[3]),.block_can_shift_right, .block_can_shift_left, .keycode, .can_rotate);
    blockStorages block2( .clk(gameClk), .reset(sReset), .state, .prev(blocks[3]), .write(next_write[2]), .collision(rows[1]), .next(blocks_in[2]), .Stop(stop[2]),.block_can_shift_right, .block_can_shift_left, .keycode, .can_rotate);
    blockStorages block1( .clk(gameClk), .reset(sReset), .state, .prev(blocks[2]), .write(next_write[1]), .collision(rows[0]), .next(blocks_in[1]), .Stop(stop[1]),.block_can_shift_right, .block_can_shift_left, .keycode, .can_rotate);
    blockStorages block0( .clk(gameClk), .reset(sReset), .state, .prev(blocks[1]), .write(next_write[0]), .collision(10'hFFFF), .next(blocks_in[0]), .Stop(stop[0]),.block_can_shift_right, .block_can_shift_left, .keycode, .can_rotate);
    
endmodule
