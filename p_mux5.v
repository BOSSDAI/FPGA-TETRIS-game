module p_mux5(a,b,s,out);
		input [4:0]a, b;
		input s;
		output [4:0]out;
		
		assign out[4:0] = s ? b[4:0]: a[4:0];
endmodule