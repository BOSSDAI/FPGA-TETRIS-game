module p_mux12_4(a,b,c,d,s0,s1,out);
	input [11:0]a,b,c,d;
	input s0,s1;
	output [11:0]out;
	wire [11:0]w1,w2;
	
	p_mux32 mux1(a,b,s0,w1);
	p_mux32 mux2(c,d,s0,w2);
	p_mux32 mux3(w1,w2,s1,out);
endmodule