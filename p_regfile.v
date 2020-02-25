module p_regfile(
	clock, ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA,
	data_readRegB,
	
	
	data_from_game,
	data_to_game,
	shape_num,
	point_xy
);
	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;
	output [31:0] data_readRegA, data_readRegB;
	
	
	input [31:0] data_from_game;
	output [31:0] data_to_game;
	input [31:0] shape_num;
	output [31:0] point_xy;

	reg[31:0] registers[31:0];
	
	always @(posedge clock or posedge ctrl_reset) begin
		if(ctrl_reset) begin
			integer i;
			for(i = 0; i < 32; i = i + 1) begin
				registers[i] = 32'd0;
			end
		end
		else begin
			registers[20] = data_from_game;
			registers[25] = shape_num;
			//registers[20] = 21;
			if(ctrl_writeEnable && ctrl_writeReg != 5'd0) begin
				registers[ctrl_writeReg] = data_writeReg;
			end
		end
	end
	
	assign data_readRegA = ctrl_writeEnable && (ctrl_writeReg == ctrl_readRegA) ? 32'bz : registers[ctrl_readRegA];
	assign data_readRegB = ctrl_writeEnable && (ctrl_writeReg == ctrl_readRegB) ? 32'bz : registers[ctrl_readRegB];
	

	assign data_to_game = registers[21];
	assign point_xy = registers[26];
	
endmodule
