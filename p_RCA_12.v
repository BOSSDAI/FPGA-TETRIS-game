module p_RCA_12(x,s);
	input [11:0] x;
	//input cin;
	output [11:0] s;
   wire cout;
	wire cin;
	wire [11:0] y;
	wire [11:0] w;
	assign cin = 1'b0;
	assign y[11:0] = 12'b1;
	
   p_fa u1(x[0], y[0], cin, s[0], w1);
   p_fa u2(x[1], y[1], w1, s[1], w2);
   p_fa u3(x[2], y[2], w2, s[2], w3);
   p_fa u4(x[3], y[3], w3, s[3], w4);
	p_fa u5(x[4], y[4], w4, s[4], w5);
   p_fa u6(x[5], y[5], w5, s[5], w6);
   p_fa u7(x[6], y[6], w6, s[6], w7);
   p_fa u8(x[7], y[7], w7, s[7], w8);
	p_fa u9(x[8], y[8], w8, s[8], w9);
   p_fa u10(x[9], y[9], w9, s[9], w10);
   p_fa u11(x[10], y[10], w10, s[10], w11);
   p_fa u12(x[11], y[11], w11, s[11], cout);
endmodule