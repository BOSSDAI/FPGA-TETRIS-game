module coordinate_getter( in, out_x, out_y);

	input [18:0] in;
	output [9:0] out_x, out_y;
	
	assign out_x = in % 640;
	assign out_y = in / 640;
endmodule
