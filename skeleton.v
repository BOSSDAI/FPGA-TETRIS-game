module skeleton(
key,
resetn, 
	ps2_clock, ps2_data, 										// ps2 related I/O
	debug_data_in, debug_addr, leds, 						// extra debugging ports
	lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon,// LCD info
	seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8,		// seven segements
	VGA_CLK,   														//	VGA Clock
	VGA_HS,															//	VGA H_SYNC
	VGA_VS,															//	VGA V_SYNC
	VGA_BLANK,														//	VGA BLANK
	VGA_SYNC,														//	VGA SYNC
	VGA_R,   														//	VGA Red[9:0]
	VGA_G,	 														//	VGA Green[9:0]
	VGA_B,															//	VGA Blue[9:0]
	CLOCK_50);  													// 50 MHz clock
		
	////////////////////////	VGA	////////////////////////////
	input [3:0]key;
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK;				//	VGA BLANK
	output			VGA_SYNC;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[9:0]
	output	[7:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[9:0]
	input				CLOCK_50;

	////////////////////////	PS2	////////////////////////////
	input 			resetn;
	inout 			ps2_data, ps2_clock;
	
	////////////////////////	LCD and Seven Segment	////////////////////////////
	output 			   lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon;
	output 	[7:0] 	leds, lcd_data;
	output 	[6:0] 	seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8;
	output 	[31:0] 	debug_data_in;
	output   [11:0]   debug_addr;
	
	
	
	
	
	wire			 clock;
	wire			 lcd_write_en;
	wire 	[31:0] lcd_write_data;
	wire	[7:0]	 ps2_key_data;
	wire			 ps2_key_pressed;
	wire	[7:0]	 ps2_out;	
	reg [7:0] lcd_in;
	
	wire [31:0] data_current_score, data_new_score;
	wire [31:0] shape_num, point_xy;
	// clock divider (by 5, i.e., 10 MHz)
	pll div(CLOCK_50,inclock);
	assign clock = CLOCK_50;
	
	// UNCOMMENT FOLLOWING LINE AND COMMENT ABOVE LINE TO RUN AT 50 MHz
	//assign clock = inclock;
	
	// your processor
	//processor myprocessor(clock, ~resetn, /*ps2_key_pressed, ps2_out, lcd_write_en, lcd_write_data,*/ debug_data_in, debug_addr);
	p_skeleton myprocessor(
		.clock(clock), 
		.reset(~resetn), 
		.imem_clock(), 
		.dmem_clock(), 
		.processor_clock(), 
		.regfile_clock(),
		.data_from_game(data_current_score),
		.data_to_game(data_new_score),
		.shape_num(shape_num),
		.point_xy(point_xy)
	);
	
	// keyboard controller
	PS2_Interface myps2(clock, resetn, ps2_clock, ps2_data, ps2_key_data, ps2_key_pressed, ps2_out);
	reg [3:0] key_keyboard;
	
	initial key_keyboard = 4'b1111;
	
	//always @ (posedge clock) begin
	always @ (posedge ps2_key_pressed) begin	
		

		
		if (ps2_out == 8'h15) begin
			lcd_in = 8'h51;
			key_keyboard = 4'b1111;end
		else if(ps2_out == 8'h1d)begin
			lcd_in = 8'h57;
			key_keyboard = 4'b1111;end
		else if(ps2_out == 8'h24) begin
			lcd_in = 8'h45;
			key_keyboard = 4'b1111;end
		else if(ps2_out == 8'h2d)begin
			lcd_in = 8'h52;
			key_keyboard = 4'b1111;end
		else 
			lcd_in = ps2_out; 
			
					
		if(ps2_out == 8'h75)
			begin
				key_keyboard[0] = 1'b0;   // up
			end
		else if(ps2_out == 8'h72)
			begin
				key_keyboard[1] = 1'b0;   // down

			end
		else if(ps2_out == 8'h6b)  
			begin
				key_keyboard[2] = 1'b0;   // left
			end
		else if(ps2_out == 8'h74)
			begin
				key_keyboard[3] = 1'b0;   // right
			end
		
			
		
		
	end
	
	// lcd controller
	lcd mylcd(clock, ~resetn, 1'b1, lcd_in, lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon);
	
	// example for sending ps2 data to the first two seven segment displays
	Hexadecimal_To_Seven_Segment hex1(ps2_out[3:0], seg1);
	Hexadecimal_To_Seven_Segment hex2(ps2_out[7:4], seg2);
	
	// the other seven segment displays are currently set to 0
	Hexadecimal_To_Seven_Segment hex3(4'b0, seg3);
	Hexadecimal_To_Seven_Segment hex4(4'b0, seg4);
	Hexadecimal_To_Seven_Segment hex5(4'b0, seg5);
	Hexadecimal_To_Seven_Segment hex6(4'b0, seg6);
	Hexadecimal_To_Seven_Segment hex7(4'b0, seg7);
	Hexadecimal_To_Seven_Segment hex8(4'b0, seg8);
	
	// some LEDs that you could use for debugging if you wanted
	assign leds = 8'b00101011;
		
	// VGA
	Reset_Delay			r0	(.iCLK(CLOCK_50),.oRESET(DLY_RST)	);
	VGA_Audio_PLL 		p1	(.areset(~DLY_RST),.inclk0(CLOCK_50),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(VGA_CLK)	);
	vga_controller vga_ins(.key(key_keyboard),
								 .iRST_n(DLY_RST),
								 .iVGA_CLK(VGA_CLK),
								 .oBLANK_n(VGA_BLANK),
								 .oHS(VGA_HS),
								 .oVS(VGA_VS),
								 .b_data(VGA_B),
								 .g_data(VGA_G),
								 .r_data(VGA_R),
								 
								 
								 .press(ps2_key_pressed),
								 .ps2_out(ps2_out),
								 
								 .new_score(data_new_score),
								 .current_score(data_current_score),
								 .shape_num(shape_num),
								 .point_xy(point_xy)
								 );
	
	
endmodule
