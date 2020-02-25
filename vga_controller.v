module vga_controller(
key,
iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,
							 
							 //
							 press,
							 ps2_out,
							 
							 //
							 new_score,
							 current_score,
							 shape_num,
							 point_xy
							 );

input press;
input [7:0]ps2_out;

							 
input [3:0]key;
input iRST_n;
input iVGA_CLK;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data; 

                       
///////// ////                     
reg [18:0] ADDR;
//reg [23:0] bgr_data;
wire [23:0] bgr_data;
reg [31:0]counter, counter2;
wire VGA_CLK_n;
wire [7:0] index;
wire [23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS,rst;

wire [9:0] x, y;
wire [9:0] xadd, yadd;
reg clk,clk_p;

wire [1:0] x0, y0, x1, y1, x2, y2, x3, y3;
wire move_reset, nl, nr;

input [31:0] new_score;
output [31:0] current_score;

output [31:0] shape_num;
input [31:0] point_xy;

////
assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));
////
////Addresss generator
always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+1;
end

///clk
initial clk = 1'b0;


///////////////////////////different level has different falling speed////////////////////////////
//always@(posedge iVGA_CLK)
//begin 
//	counter<=counter+1;
//	//if(counter == 10000000)
//	if(counter == 8000000)
//	begin
//	clk = ~clk;
//	counter <= 32'b0;
//	end
//end


reg [1:0] level;

initial begin
	level = 0;
end

always@(posedge iVGA_CLK)begin
	if(current_score<3)begin
		level <=0;
	end
	else if (current_score<5)begin
		level <=1;
	end
	else begin
		level <=2;
	end
end

always@(posedge iVGA_CLK)
begin 
	counter<=counter+1;
	
	if(level == 0)begin
		if(counter == 11000000)
		begin
		clk = ~clk;
		counter <= 32'b0;
		end
	end
	
	else if(level == 1) begin
		if(counter >= 8000000)
		begin
		clk = ~clk;
		counter <= 32'b0;
		end
	end
	
	else if(level == 2) begin
		if(counter >= 6000000)
		begin
		clk = ~clk;
		counter <= 32'b0;
		end
	end
end

////////////////////////////////////////////////////////////////////////////////////////////////////

initial clk_p = 1'b0;
always@(posedge iVGA_CLK)
begin 
	counter2<=counter2+1;
	if(counter2 == 2000000)
	//if(counter2 == 1500000)
	begin
	clk_p = ~clk_p;
	counter2 <= 32'b0;
	end
end


reg _press_;
wire _press;
assign _press = _press_;
reg counter3;
	
	always@(posedge clk_p or posedge press)begin
		if(press == 1) begin
			_press_ <= 1'b1;
		end
		else if(clk_p == 1'b1) begin
			if(counter3 == 1'b1)begin
			counter3 <= 0;
			_press_ <= 0;
		   end
			
		   else if(_press_ == 1'b1)begin
				counter3 <= counter3+1;
			end
		end
		
		
	end
//////////////////////////
//////INDEX addr.
assign VGA_CLK_n = ~iVGA_CLK;
img_data	img_data_inst (
	.address ( ADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index )
	);
	
/////////////////////////
//////Add switch-input logic here
	
//////Color table output
//img_index	img_index_inst (
//	.address ( index ),
//	.clock ( iVGA_CLK ),	
//	.q ( bgr_data_raw)
//	);	
//////

coordinate_getter corrdinate_getter_inst(
	.in(ADDR), 
	.out_x(x), 
	.out_y(y),

);


wire[2:0]shape;
wire[1:0]direction;
wire lfalg;
back_ctr _back_ctr(
	.iRST_n(iRST_n),
	.VGA_CLK_n(VGA_CLK_n),
	.x(x), 
	.y(y),
	.xadd(xadd),
	.yadd(yadd),
	.x0(x0), .y0(y0),
	.x1(x1), .y1(y1),
	.x2(x2), .y2(y2),
	.x3(x3), .y3(y3),
	.bgr_data_raw(bgr_data_raw),
	.move_reset(move_reset),
	.nl(nl), .nr(nr),
	.new_score(new_score),
	.current_score(current_score),
	.direction(direction), ////////////for left boundary
	.shape(shape), ////////////////for left boundary
	.lflag(lflag)
);


wire [2:0]sh_;
move move_inst(
	.move_reset(move_reset),
	.press(_press),
	.nl(nl), .nr(nr),
	.clock(clk),
	.clk_hi(VGA_CLK_n),
	.in(ps2_out),
	.out_x(xadd),
	.out_y(yadd),
	.sh_(sh_));

//////latch valid data at falling edge;
//wire [23:0] bgr_data;



shape shape1(
	sh_,
	VGA_CLK_n,
	clk,
	_press, 
	move_reset,
	ps2_out, 
	x, y, 
	xadd, yadd, 
	bgr_data_raw, 
	bgr_data,
	x0, y0,
	x1, y1,
	x2, y2,
	x3, y3,
	direction, ////////////for left boundary
	shape, ////////////////for left boundary
	lflag,
	shape_num,
	point_xy
);


	
	
	
	
assign b_data = bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign r_data = bgr_data[7:0]; 





///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end

endmodule
 	















