module shape(
	sh_,///////////////////
	VGA_CLK_n, 
	clk,
	press, 
	move_reset,
	in, 
	x, 
	y, 
	xadd, 
	yadd, 
	bgr_data_raw, 
	bgr_data, 
	x0, y0,
	x1, y1,
	x2, y2,
	x3, y3,
	direction, ///////left boundary rotation
	shape, /////////left
	lflag,
	shape_num,
	point_xy
);
input [2:0] sh_;
input VGA_CLK_n,clk, press, move_reset;
input [7:0] in;
input [9:0] x, y, xadd, yadd;
input [23:0] bgr_data_raw;

output reg [23:0] bgr_data;
//output reg [1:0] x0, y0, x1, y1, x2, y2, x3, y3;
output [1:0] x0, y0, x1, y1, x2, y2, x3, y3;
assign x0[1:0] = point_xy[29:28];
assign y0[1:0] = point_xy[25:24];
assign x1[1:0] = point_xy[21:20];
assign y1[1:0] = point_xy[17:16];
assign x2[1:0] = point_xy[13:12];
assign y2[1:0] = point_xy[9:8];
assign x3[1:0] = point_xy[5:4];
assign y3[1:0] = point_xy[1:0];

//reg [2:0] shape;
//reg [1:0] direction;
output reg [2:0] shape;
output reg [1:0] direction;
input lflag;

input [31:0] point_xy;
output reg[31:0] shape_num;

initial shape = 3'b000;


/////////////////////////////////////////////random 变形////////////////////////////////////////////
//always@(posedge clk)begin
//	if (move_reset == 1 && shape < 5) begin
//		shape <= shape + 1;
//	end
//	else if (shape == 5) begin
//		shape <= 0;
//	end
//
//end

always@(posedge clk)begin
	if (move_reset == 1 ) begin
		shape <= sh_;
	end
end
/////////////////////////////////////////////////////////////////////////////////////////////////////


always@(negedge press) begin
	if (in == 8'h75) begin
		if (direction == 2'b11) begin
			direction <= 2'b00;
		end
		else
			if(lflag == 1) begin
				direction <= 1 + direction;
			end
	end
end


always@(posedge VGA_CLK_n) 
	begin
	
		//square
		if (shape == 3'b000 || shape == 3'b101) begin
		       shape_num <= 0;
//				x0 <= 2'b00;
//				y0 <= 2'b00;
//				 
//				x1 <= 2'b00;
//				y1 <= 2'b01;
//				
//				x2 <= 2'b01;
//				y2 <= 2'b00;
//				
//				x3 <= 2'b01;
//				y3 <= 2'b01;
				
				if (x>=xadd && x<=xadd+80 && y>=yadd && y<=yadd+80)
					bgr_data <= 24'h67676;
				else
					bgr_data <= bgr_data_raw;
		end
		
		//rectangular
		if (shape == 3'b001 ) begin
				if (direction == 2'b00 || direction == 2'b10) begin 
				shape_num <= 1;
//				x0 <= 2'b00;
//				y0 <= 2'b00;
//				 
//				x1 <= 2'b00;
//				y1 <= 2'b01;
//				
//				x2 <= 2'b00;
//				y2 <= 2'b10;
//				
//				x3 <= 2'b00;
//				y3 <= 2'b11;
				
					if(x>=xadd && x<=xadd+40 && y>=yadd && y<=yadd+160) begin
						bgr_data <= 24'h67676;
					end
					else
						bgr_data <= bgr_data_raw;
				end
				else if (direction == 2'b01 || direction == 2'b11) begin
				shape_num <= 2;
//				x0 <= 2'b00;
//				y0 <= 2'b00;
//				 
//				x1 <= 2'b01;
//				y1 <= 2'b00;
//				
//				x2 <= 2'b10;
//				y2 <= 2'b00;
//				
//				x3 <= 2'b11;
//				y3 <= 2'b00;
					if(x>=xadd && x<=xadd+160 && y>=yadd && y<=yadd+40) begin
						bgr_data <= 24'h67676;
					end
					else
						bgr_data <= bgr_data_raw;
				end
		end
	//L
	if (shape == 3'b010) begin
		if(direction == 2'b00) begin
		shape_num <= 3;
//			x0 <= 2'b00;
//			y0 <= 2'b00;
//				 
//			x1 <= 2'b00;
//			y1 <= 2'b01;
//				
//			x2 <= 2'b01;
//			y2 <= 2'b01;
//				
//			x3 <= 2'b10;
//			y3 <= 2'b01;
			if((x>=xadd && x<=xadd+40 && y>=yadd && y<=yadd+80) ||(x>=xadd+40 && x<=xadd+120 && y>=yadd+40 && y<=yadd+80))
				bgr_data <= 24'h67676;
			else
				bgr_data <= bgr_data_raw;
		end
		if(direction == 2'b01) begin
		shape_num <= 4;
//			x0 <= 2'b00;
//			y0 <= 2'b00;
//				 
//			x1 <= 2'b01;
//			y1 <= 2'b00;
//				
//			x2 <= 2'b00;
//			y2 <= 2'b01;
//				
//			x3 <= 2'b00;
//			y3 <= 2'b10;
			if((x>=xadd && x<=xadd+80 && y>=yadd && y<=yadd+40) ||(x>=xadd && x<=xadd+40 && y>=yadd+40 && y<=yadd+120))
				bgr_data <= 24'h67676;
			else
				bgr_data <= bgr_data_raw;
		end
		if(direction == 2'b10) begin
		shape_num <= 5;
//			x0 <= 2'b00;
//			y0 <= 2'b00;
//				 
//			x1 <= 2'b01;
//			y1 <= 2'b00;
//				
//			x2 <= 2'b10;
//			y2 <= 2'b00;
//				
//			x3 <= 2'b10;
//			y3 <= 2'b01;
			if((x>=xadd && x<=xadd+80 && y>=yadd && y<=yadd+40) ||(x>=xadd+80 && x<=xadd+120 && y>=yadd && y<=yadd+80))
				bgr_data <= 24'h67676;
			else
				bgr_data <= bgr_data_raw;
		end
		if(direction == 2'b11) begin
		shape_num <= 6;
//			x0 <= 2'b01;
//			y0 <= 2'b00;
//				 
//			x1 <= 2'b01;
//			y1 <= 2'b01;
//				
//			x2 <= 2'b01;
//			y2 <= 2'b10;
//				
//			x3 <= 2'b00;
//			y3 <= 2'b10;
			if((x>=xadd+40 && x<=xadd+80 && y>=yadd && y<=yadd+120) ||(x>=xadd && x<=xadd+40 && y>=yadd+80 && y<=yadd+120))
				bgr_data <= 24'h67676;
			else
				bgr_data <= bgr_data_raw;
		end
	end
	//T
	if (shape == 3'b011) begin
		if(direction == 2'b00) begin
		shape_num <= 7;
//			x0 <= 2'b00;
//			y0 <= 2'b00;
//				 
//			x1 <= 2'b00;
//			y1 <= 2'b01;
//				
//			x2 <= 2'b00;
//			y2 <= 2'b10;
//				
//			x3 <= 2'b01;
//			y3 <= 2'b01;
			if((x>=xadd && x<=xadd+40 && y>=yadd && y<=yadd+120) ||(x>=xadd+40 && x<=xadd+80 && y>=yadd+40 && y<=yadd+80))
				bgr_data <= 24'h67676;
			else
				bgr_data <= bgr_data_raw;
		end
		if(direction == 2'b01) begin
		shape_num <= 8;
//			x0 <= 2'b00;
//			y0 <= 2'b00;
//				 
//			x1 <= 2'b01;
//			y1 <= 2'b00;
//				
//			x2 <= 2'b10;
//			y2 <= 2'b00;
//				
//			x3 <= 2'b01;
//			y3 <= 2'b01;
			if((x>=xadd && x<=xadd+120 && y>=yadd && y<=yadd+40) ||(x>=xadd+40 && x<=xadd+80 && y>=yadd+40 && y<=yadd+80))
				bgr_data <= 24'h67676;
			else
				bgr_data <= bgr_data_raw;
		end
		if(direction == 2'b10) begin
		shape_num <= 9;
//			x0 <= 2'b01;
//			y0 <= 2'b00;
//				 
//			x1 <= 2'b01;
//			y1 <= 2'b01;
//				
//			x2 <= 2'b01;
//			y2 <= 2'b10;
//				
//			x3 <= 2'b00;
//			y3 <= 2'b01;
			if((x>=xadd+40 && x<=xadd+80 && y>=yadd && y<=yadd+120) ||(x>=xadd && x<=xadd+40 && y>=yadd+40 && y<=yadd+80))
				bgr_data <= 24'h67676;
			else
				bgr_data <= bgr_data_raw;
		end
		if(direction == 2'b11) begin
		shape_num <= 10;
//			x0 <= 2'b01;
//			y0 <= 2'b00;
//				 
//			x1 <= 2'b00;
//			y1 <= 2'b01;
//				
//			x2 <= 2'b01;
//			y2 <= 2'b01;
//				
//			x3 <= 2'b10;
//			y3 <= 2'b01;
			if((x>=xadd+40 && x<=xadd+80 && y>=yadd && y<=yadd+40) ||(x>=xadd && x<xadd+120 && y>=yadd+40 && y<=yadd+80))
				bgr_data <= 24'h67676;
			else
				bgr_data <= bgr_data_raw;
		end
	
		
	end
	
	//Z
	if (shape == 3'b100) begin
		if(direction == 2'b00 ||direction == 2'b10) begin
		shape_num <= 11;
//			x0 <= 2'b00;
//			y0 <= 2'b00;
//				 
//			x1 <= 2'b00;
//			y1 <= 2'b01;
//				
//			x2 <= 2'b01;
//			y2 <= 2'b01;
//				
//			x3 <= 2'b01;
//			y3 <= 2'b10;
			if((x>=xadd && x<=xadd+40 && y>=yadd && y<=yadd+80) ||(x>=xadd+40 && x<=xadd+80 && y>=yadd+40 && y<=yadd+120))
				bgr_data <= 24'h27676;
			else
				bgr_data <= bgr_data_raw;
		end
		if(direction == 2'b01 || direction == 2'b11) begin
		shape_num <= 12;
//			x0 <= 2'b01;
//			y0 <= 2'b00;
//				 
//			x1 <= 2'b10;
//			y1 <= 2'b00;
//				
//			x2 <= 2'b00;
//			y2 <= 2'b01;
//				
//			x3 <= 2'b01;
//			y3 <= 2'b01;
			if((x>=xadd+40 && x<=xadd+120 && y>=yadd && y<=yadd+40) ||(x>=xadd && x<=xadd+80 && y>=yadd+40 && y<=yadd+80))
				bgr_data <= 24'h27676;
			else
				bgr_data <= bgr_data_raw;
		end
		
	end
	end
//	

	
endmodule
