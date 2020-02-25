module p_mux(a,b,s,out);
		input a, b;
		input s;
		output out;
		
		assign out = s ? b: a;
endmodule