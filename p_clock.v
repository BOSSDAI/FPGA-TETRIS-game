module p_clock(clock, reset,  Imem_clk, Dmem_clk, PC_clk,Reg_clk);
  input clock,reset;
  output PC_clk, Imem_clk, Reg_clk, Dmem_clk;
  reg clk_25,clk_4;
  reg counter;

always@(posedge clock or posedge reset)begin
	if(reset)begin
		clk_25<=0;
	end
	else begin
   clk_25 = ~clk_25;
	end
end


always @(posedge clock or posedge reset) begin
	if (reset) begin
		// reset
		counter <= 0;
	end
	else if (counter == 1) begin
		counter <= 0;
	end
	else begin
		counter <= counter + 1;
	end
end

always @(posedge clock or posedge reset) begin
	if (reset) begin
		// reset
		clk_4 <= 0;
	end
	else if (counter == 1) begin
		clk_4 <= !clk_4;
	end
end

 assign PC_clk = ~clk_25 & ~clk_4;
 assign Reg_clk = clk_25 & clk_4;
 assign Imem_clk = clk_25 & ~clk_4;
 assign Dmem_clk = ~clk_25 & clk_4;

endmodule