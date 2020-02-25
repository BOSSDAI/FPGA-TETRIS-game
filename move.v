module move(move_reset, nl, nr, press, clock, clk_hi, in, out_x,out_y,sh_);
	input move_reset, nl, nr;
	input press, clock, clk_hi;
	input [7:0] in;
	output [9:0] out_x, out_y;
	output [2:0] sh_;
	reg [9:0]  x, y;
	
	reg [31:0]counter1,counter2;
	reg new1;
	
	reg [9:0] c_shape;/////////////////////
	reg [2:0] sh;
	assign sh_ = sh;
	initial begin
		x = 10'b0;
		y = 10'b0;
		counter1 = 31'b0;
		counter2 = 31'b0;
	end


wire new_clock;

assign new_clock = move_reset? clock:press;
always@(negedge new_clock) begin
	if(clock == 1 && move_reset ==1 )begin
		  if(y < 10) begin
		   x <= 200;
		  end
	end
	
	else if(press == 1 ) begin
		c_shape <= c_shape+1;
		sh <= c_shape % 5;
		if(in == 8'h6b && x > 0 && ~nl) begin
				x <= x - 40;
			end
			else if(in == 8'h74 && x < 540 && ~nr) begin
				x <= x + 40;
			end	
	end		
end

	 
always@(posedge clock) begin

		if(move_reset == 1) begin

			y <= 10'b0;
		end

		else if(y < 420) begin
			y <= y + 40;

		end
end



assign out_x = x;
assign out_y = y;
 
endmodule
 