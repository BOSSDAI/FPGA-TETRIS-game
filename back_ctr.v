module back_ctr(
	iRST_n,
	VGA_CLK_n,
	//move_clock,
	x, 
	y,
	xadd,
	yadd,
	x0, y0,
	x1, y1,
	x2, y2,
	x3, y3,
	
	
	bgr_data_raw,
	
	
	move_reset,
	nl,
	nr,
	
	new_score,
	current_score,
	
	direction, ////////////for left boundary
	shape, ////////////////for left boundary
	lflag
);
	input iRST_n;
	input VGA_CLK_n;
	//input move_clock;
	input [9:0] x, y;
	input [9:0] xadd, yadd;
	input [1:0] x0, y0, x1, y1, x2, y2, x3, y3;
	input [31:0] new_score;
	
	input [1:0]direction;
	input [2:0]shape;
	output reg lflag;
	
	
	output reg [23:0] bgr_data_raw;
	
	output reg move_reset, nr, nl;
	
	
	reg [10:0]back [0:22];
	reg [9:0] current_line;
	reg current_bit;
	output reg [31:0] current_score;
	wire [3:0] score_h;
	wire [3:0] score_l;
	
	wire [9:0] line0, line1, line2, line3;
	
	wire [3:0] i, j;
	wire [3:0] xx, yy;
	reg reset,flag;
	reg [31:0]counter ;
	
	// four key points
	wire [3:0] key_points;
	assign j = x/40;    // column
	assign i = y/40;    // line
	
	assign xx = xadd/40;
	assign yy = yadd/40;
	
	

	
	initial begin
		reset = 1'b1;
		move_reset = 1'b0;
		nr = 1'b0;
		nl = 1'b0;
		//score = 8'b00000000;
	end

	
	assign score_l = current_score % 10;
	assign score_h = current_score / 10;
	
//	always@(posedge move_clock) begin
//		current_score <= new_score;
//		if (score_add == 1) begin
//		
//		end
//	
//	end

	always @(posedge VGA_CLK_n) begin
		//current_score <= new_score;
		if(!iRST_n)begin
			counter <= 0;
			begin
				integer i; 
			
			  for(i = 0;i < 12 ;i = i+1)begin
				 back[i] <= 11'b10000000000; 
		  end
		 end
		end
		back[12] <= 11'b11111111111;
		
		//counter for xiaohang
		if(flag == 1)begin
			counter <= counter +1;
		end
		
		if (counter == 19999998)begin
			flag <=0;
			counter<=0;
			begin
						integer i_line;
						integer j_line;
						for(i_line = 0; i_line < 12; i_line = i_line + 1) begin
							if (back[i_line] == 11'b11111111111)begin								
								// score <= score + 1;
								current_score <= new_score;
								for(j_line = i_line; j_line > 1; j_line = j_line - 1) begin
									back[j_line] <= back[j_line - 1];
									
								end
							end
						end						
			end

		end
		
		if (x < 400) begin		
			//if (current_bit == 1'b1) begin
			if(back[i][j] == 1'b1)begin
				bgr_data_raw <= 24'h67676;
				
			end
			else bgr_data_raw <= 24'h00000;
			
			
	
	
		end
		
		
		else if(x<510) begin
			case(score_h)
			0:begin
				if((x>=440&&x<=500&&y>=40&&y<=60)||(x>=440&&x<=500&&y>=120&&y<=140)
				||(x>=440&&x<=460&&y>=60&&y<=120)||(x>=480&&x<=500&&y>=60&&y<=120))
				begin
					bgr_data_raw <= 24'h006633;
				end
				else begin
					bgr_data_raw <= 24'hffeedd;
				end
			end
			1:
			begin
				if((x>=440&&x<=480&&y>=40&&y<=60)||(x>=460&&x<=480&&y>=60&&y<=120)
				||(x>=440&&x<=500&&y>=120&&y<=140))
				begin
					bgr_data_raw <= 24'h006633;
				end
				else begin
					bgr_data_raw <= 24'hffeedd;
				end
			end
			2:
			begin
				if((x>=440&&x<=500&&y>=40&&y<=60)||(x>=480&&x<=500&&y>=60&&y<=80)
				||(x>=440&&x<=500&&y>=80&&y<=100)||(x>=440&&x<=460&&y>=100&&y<=120)
				||(x>=440&&x<=500&&y>=120&&y<=140))
				begin
					bgr_data_raw <= 24'h006633;
				end
				else begin
					bgr_data_raw <= 24'hffeedd;
				end
			end
			3:
			begin
			if((x>=440&&x<=500&&y>=40&&y<=60)||(x>=480&&x<=500&&y>=60&&y<=80)
			||(x>=440&&x<=500&&y>=80&&y<=100)||(x>=480&&x<=500&&y>=100&&y<=120)
			||(x>=440&&x<=500&&y>=120&&y<=140))
				begin
					bgr_data_raw <= 24'h006633;
				end
				else begin
					bgr_data_raw <= 24'hffeedd;
				end
			end
			4:
			begin
			if((x>=440&&x<=460&&y>=40&&y<=100)||(x>=460&&x<=480&&y>=80&&y<=100)
			||(x>=480&&x<=500&&y>=40&&y<=140))
				begin
					bgr_data_raw <= 24'h006633;
				end
				else begin
					bgr_data_raw <= 24'hffeedd;
				end
			end
			5:
			begin
			if((x>=440&&x<=500&&y>=40&&y<=60)||(x>=440&&x<=460&&y>=60&&y<=80)
			||(x>=440&&x<=500&&y>=80&&y<=100)||(x>=480&&x<=500&&y>=100&&y<=120)
			||(x>=440&&x<=500&&y>=120&&y<=140))
				begin
					bgr_data_raw <= 24'h006633;
				end
				else begin
					bgr_data_raw <= 24'hffeedd;
				end
			end
			6:
			begin
			if((x>=440&&x<=460&&y>=40&&y<=140)||(x>=460&&x<=500&&y>=40&&y<=60)
			||(x>=460&&x<=500&&y>=80&&y<=100)||(x>=480&&x<=500&&y>=100&&y<=120)
			||(x>=460&&x<=500&&y>=120&&y<=140))
				begin
					bgr_data_raw <= 24'h006633;
				end
				else begin
					bgr_data_raw <= 24'hffeedd;
				end
			end
			7:
			begin
			if((x>=440&&x<=500&&y>=40&&y<=60)||(x>=480&&x<=500&&y>=60&&y<=140))
				begin
					bgr_data_raw <= 24'h006633;
				end
				else begin
					bgr_data_raw <= 24'hffeedd;
				end
			end
			8:
			begin
			if((x>=440&&x<=500&&y>=40&&y<=60)||(x>=480&&x<=500&&y>=60&&y<=140)
			||(x>=440&&x<=460&&y>=60&&y<=140)||(x>=460&&x<=480&&y>=120&&y<=140)
			||(x>=460&&x<=480&&y>=80&&y<=100))
				begin
					bgr_data_raw <= 24'h006633;
				end
				else begin
					bgr_data_raw <= 24'hffeedd;
				end
			end
			9:
			begin
			if((x>=440&&x<=500&&y>=40&&y<=60)||(x>=440&&x<=500&&y>=80&&y<=100)
			||(x>=440&&x<=500&&y>=120&&y<=140)||(x>=440&&x<=460&&y>=60&&y<=80)
			||(x>=480&&x<=500&&y>=60&&y<=80)||(x>=480&&x<=500&&y>=100&&y<=120))
				begin
					bgr_data_raw <= 24'h006633;
				end
				else begin
					bgr_data_raw <= 24'hffeedd;
				end
			end
			
		endcase	
		end
		else begin
			//score_l <= score+1;
			case(score_l)
			0:begin
				if((x>=540&&x<=600&&y>=40&&y<=60)||(x>=540&&x<=600&&y>=120&&y<=140)
				||(x>=540&&x<=560&&y>=60&&y<=120)||(x>=580&&x<=600&&y>=60&&y<=120))
				begin
					bgr_data_raw <= 24'h006633;
				end
				else begin
					bgr_data_raw <= 24'hffeedd;
				end
			end
			1:
			begin
				if((x>=540&&x<=580&&y>=40&&y<=60)||(x>=560&&x<=580&&y>=60&&y<=120)
				||(x>=540&&x<=600&&y>=120&&y<=140))
				begin
					bgr_data_raw <= 24'h006633;
				end
				else begin
					bgr_data_raw <= 24'hffeedd;
				end
			end
			2:
			begin
				if((x>=540&&x<=600&&y>=40&&y<=60)||(x>=580&&x<=600&&y>=60&&y<=80)
				||(x>=540&&x<=600&&y>=80&&y<=100)||(x>=540&&x<=560&&y>=100&&y<=120)
				||(x>=540&&x<=600&&y>=120&&y<=140))
				begin
					bgr_data_raw <= 24'h006633;
				end
				else begin
					bgr_data_raw <= 24'hffeedd;
				end
			end
			3:
			begin
			if((x>=540&&x<=600&&y>=40&&y<=60)||(x>=580&&x<=600&&y>=60&&y<=80)
			||(x>=540&&x<=600&&y>=80&&y<=100)||(x>=580&&x<=600&&y>=100&&y<=120)
			||(x>=540&&x<=600&&y>=120&&y<=140))
				begin
					bgr_data_raw <= 24'h006633;
				end
				else begin
					bgr_data_raw <= 24'hffeedd;
				end
			end
			4:
			begin
			if((x>=540&&x<=560&&y>=40&&y<=100)||(x>=560&&x<=580&&y>=80&&y<=100)
			||(x>=580&&x<=600&&y>=40&&y<=140))
				begin
					bgr_data_raw <= 24'h006633;
				end
				else begin
					bgr_data_raw <= 24'hffeedd;
				end
			end
			5:
			begin
			if((x>=540&&x<=600&&y>=40&&y<=60)||(x>=540&&x<=560&&y>=60&&y<=80)
			||(x>=540&&x<=600&&y>=80&&y<=100)||(x>=580&&x<=600&&y>=100&&y<=120)
			||(x>=540&&x<=600&&y>=120&&y<=140))
				begin
					bgr_data_raw <= 24'h006633;
				end
				else begin
					bgr_data_raw <= 24'hffeedd;
				end
			end
			6:
			begin
			if((x>=540&&x<=560&&y>=40&&y<=140)||(x>=560&&x<=600&&y>=40&&y<=60)
			||(x>=560&&x<=600&&y>=80&&y<=100)||(x>=580&&x<=600&&y>=100&&y<=120)
			||(x>=560&&x<=600&&y>=120&&y<=140))
				begin
					bgr_data_raw <= 24'h006633;
				end
				else begin
					bgr_data_raw <= 24'hffeedd;
				end
			end
			7:
			begin
			if((x>=540&&x<=600&&y>=40&&y<=60)||(x>=580&&x<=600&&y>=60&&y<=140))
				begin
					bgr_data_raw <= 24'h006633;
				end
				else begin
					bgr_data_raw <= 24'hffeedd;
				end
			end
			8:
			begin
			if((x>=540&&x<=600&&y>=40&&y<=60)||(x>=580&&x<=600&&y>=60&&y<=140)
			||(x>=540&&x<=560&&y>=60&&y<=140)||(x>=560&&x<=580&&y>=120&&y<=140)
			||(x>=560&&x<=580&&y>=80&&y<=100))
				begin
					bgr_data_raw <= 24'h006633;
				end
				else begin
					bgr_data_raw <= 24'hffeedd;
				end
			end
			9:
			begin
			if((x>=540&&x<=600&&y>=40&&y<=60)||(x>=540&&x<=600&&y>=80&&y<=100)
			||(x>=540&&x<=600&&y>=120&&y<=140)||(x>=540&&x<=560&&y>=60&&y<=80)
			||(x>=580&&x<=600&&y>=60&&y<=80)||(x>=580&&x<=600&&y>=100&&y<=120))
				begin
					bgr_data_raw <= 24'h006633;
				end
				else begin
					bgr_data_raw <= 24'hffeedd;
				end
			end
		endcase
		end
		
		if(back[yy+y0+1][xx+x0] == 1 ||back[yy+y1+1][xx+x1] == 1||
				back[yy+y2+1][xx+x2] == 1 ||back[yy+y3+1][xx+x3]== 1) begin
					begin
						move_reset <= 1;
						nl = 1'b1;
						nr = 1'b1;
						flag <=1;
						if(counter > 11900000&&counter < 12999996) begin
						
							back[yy+y0][xx+x0] <= 1'b1;
							back[yy+y1][xx+x1] <= 1'b1;
							back[yy+y2][xx+x2] <= 1'b1;
							back[yy+y3][xx+x3] <= 1'b1;
						end
						
					end
			end
			
			
				else begin
					move_reset <= 0;
					nr = 1'b0;
					nl = 1'b0;
				end
				
			// 左碰撞
			if(back[yy+y0][xx+x0-1] == 1 ||back[yy+y1][xx+x1-1] == 1||
				back[yy+y2][xx+x2-1] == 1 ||back[yy+y3][xx+x3-1]== 1) begin
					nl <= 1'b1;
			end
			else nl <= 1'b0;
			// 右碰撞
			if(back[yy+y0][xx+x0+1] == 1 ||back[yy+y1][xx+x1+1] == 1||
				back[yy+y2][xx+x2+1] == 1 ||back[yy+y3][xx+x3+1]== 1) begin
					nr <= 1'b1;
			end
			else nr <= 1'b0;	
			
			
			//////////////////left boundary rotation
			if(shape == 0) begin   ////////////////square
				lflag <=1;
			end
			
			else if(shape ==1)begin ///////////////rectangular
				if(direction == 2'b00 || direction == 2'b10) begin
					if(( xx + x0 ) > 6)begin
						lflag<=0;
					end
					else begin
						lflag <=1;
					end
					
				end
				else begin
					lflag <=1;
				end
			
			end
			
			else if (shape == 2)begin ///////////////L
			   if((direction == 2'b01) || (direction == 2'b11)) begin
					if(( xx + x0 ) > 7)begin
						lflag<=0;
					end
					else begin
						lflag <=1;
					end
					
				end
				else begin
					lflag <=1;
				end
			end
			
			else if (shape ==3)begin ///////////////T
				if(direction == 2'b00) begin
					if(( xx + x0 ) > 7)begin
						lflag<=0;
					end
					else begin
						lflag <=1;
					end
				end
				
				else if (direction == 2'b10) begin
					if(( xx + x0 ) > 8)begin
						lflag<=0;
					end
					else begin
						lflag <=1;
					end
				end
	
				else begin
					lflag <=1;
				end
				
			end
			
			else if (shape == 4) begin ////////////Z
			   if((direction == 2'b00) || (direction == 2'b10)) begin
					if(( xx + x0 ) > 7)begin
						lflag<=0;
					end
					else begin
						lflag <=1;
					end
					
				end
				else begin
					lflag <=1;
				end
			end
			
			else begin
				lflag <=1;
			end
	
////	
	end
endmodule
