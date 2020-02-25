module p_mux32(a,b,s,out);
		input [31:0]a, b;
		input s;
		output [31:0]out;
		
		assign out[31:0] = s ? b[31:0]: a[31:0];
endmodule