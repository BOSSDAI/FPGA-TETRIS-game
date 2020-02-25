module p_mux12(a,b,s,out);
		input [11:0]a, b;
		input s;
		output [11:0]out;
		
		assign out[11:0] = s ? b[11:0]: a[11:0];
endmodule