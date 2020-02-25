module p_register_12(q, d, clk, en, clr);
//module flop ();
	input        clk, en, clr;
	input  [11:0] d;
	output [11:0] q;
	//reg    [31:0] q;
   
	genvar i;
	
	 generate
		for(i = 0; i < 12; i=i+1) begin:block1
			p_dffe_ref dff1(q[i], d[i], clk, en, clr);
		end
	 endgenerate 
endmodule