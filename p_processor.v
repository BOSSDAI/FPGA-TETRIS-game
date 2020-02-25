/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module p_processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile 
	 );

    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;


    /* YOUR CODE STARTS HERE */
	 wire [15:0]ctrl_out;
	 wire [11:0]d;
	 wire [11:0]address_imem_1;
	 assign address_imem = address_imem_1;
	 assign data = data_readRegB;

	 
	//pc
	 p_register_12 pc(.q(address_imem_1[11:0]), .d(wire_pc), 
						 .clk(clock), .en(1'b1), .clr(reset));
	 p_RCA_12 adder_pc(.x(address_imem_1[11:0]),.s(d));
						 
	 //controller
		//[0]Rwe,[1]Rdst,[2]ALUinB,[3]DMem,[4]BR,[5]JP1,[6]JP2,[7]Rwd1,[8]Rwd0,[9]jal,
		//[10]blt,[11]bex,[12]setx,[13]aluop,[14]add.sub,[15]addi
	 p_controller controller1(.opcoder(q_imem[31:27]),.out(ctrl_out[15:0]));
	 
	 
	 //regfile
	 assign ctrl_writeEnable = ctrl_out[0];
	 assign wren = ctrl_out[3];
	 
	 //alu
	 wire [31:0]data_result;
	 wire [31:0]data_operandB;
	 wire [31:0]immi;
	 wire [4:0]wire_aluop;
	 wire [4:0]alu_addop;
	 wire isnote,lessthan,overflow;
	 assign immi[31:17] = q_imem[16] == 0? 15'b0:15'b111111111111111;
	 assign immi[16:0] = q_imem[16:0];
	 assign address_dmem[11:0] = data_result[11:0];
	 assign alu_addop = 5'b00000;
	 p_mux32 mux_ALUinB(.a(data_readRegB),.b(immi),.s(ctrl_out[2]),.out(data_operandB));
	 p_mux5 mux_aluop(.a(q_imem[6:2]),.b(alu_addop),.s(ctrl_out[13]),.out(wire_aluop));
	 p_alu alu1(.data_operandA(data_readRegA), 
				 .data_operandB(data_operandB), 
				 .ctrl_ALUopcode(wire_aluop),
			    .ctrl_shiftamt(q_imem[11:7]), 
				 .data_result(data_result), .isNotEqual(isnote), 
				 .isLessThan(lessthan), .overflow(overflow));
	 
	 //
	 wire [4:0]wire_rdst;
	 wire [4:0]reg_30;
	 wire [4:0]reg_31;
	 wire [4:0]wire_bex;
	 wire wire_overflow;
	 wire overflow_mux;
	 wire wire_3;
	 wire overflow_control;
	 wire wire_add;
	 wire wire_sub;
	 wire [31:0]wire_rwd;
	 wire [31:0]wire_setx27;
	 wire [31:0]reg_1;
	 wire [31:0]reg_2;
	 wire [31:0]reg_3;
	 wire [31:0]wire_reg;
	 wire s0,s1,or1,or2;
	 wire [31:0]store_address;
	 assign reg_30 = 5'b11110;
	 assign reg_31 = 5'b11111;
	 assign wire_bex = 5'b00000;
	 assign wire_overflow = 1'b0;
	 assign wire_setx27[31:27] = 5'b00000;
	 assign wire_setx27[26:0] = q_imem[26:0];
	 assign reg_1 = 32'h1;
	 assign reg_2 = 32'h2;
	 assign reg_3 = 32'h3;
	 assign store_address[31:12] = 20'b0;
	 assign store_address[11:0] = d[11:0];
	 p_mux5 mux_rdst(.a(wire_rdst),.b(q_imem[16:12]),.s(ctrl_out[1]),.out(ctrl_readRegB));
	 p_mux5 mux_3(.a(q_imem[26:22]),.b(reg_30),.s(wire_3),.out(wire_rdst));
	 p_mux5 mux_jal(.a(wire_rdst),.b(reg_31),.s(ctrl_out[9]),.out(ctrl_writeReg));
	 p_mux5 mux_bex(.a(q_imem[21:17]),.b(wire_bex),.s(ctrl_out[11]),.out(ctrl_readRegA));
	 or or_3(wire_3,ctrl_out[11],ctrl_out[12],overflow_mux);
	 
	 
	 //mux_overflow
	 p_mux mux_overflow(.a(wire_overflow),.b(overflow),.s(overflow_control),.out(overflow_mux));//
	 or or_overflow_control(overflow_control,ctrl_out[15],wire_add,wire_sub);
	 and and_add(wire_add,ctrl_out[14],~q_imem[2],~q_imem[3],~q_imem[4]);
	 and and_sub(wire_sub,ctrl_out[14],q_imem[2],~q_imem[3],~q_imem[4]);
	 
	 p_mux32_4 mux_rwd(.a(data_result),.b(store_address),.c(q_dmem),.d(wire_setx27),.s0(ctrl_out[8]),.s1(ctrl_out[7]),.out(wire_rwd));
	 
	 //mux_reg
	 p_mux32_4 mux_reg(.a(wire_rwd),.b(reg_1),.c(reg_2),.d(reg_3),.s0(s0),.s1(s1),.out(wire_reg));
	 and and_s0(s0,overflow,or2,);
	 and and_s1(s1,overflow,or1);
	 or or_1(or1,ctrl_out[15],wire_sub);
	 or or_2(or2,wire_sub,wire_add);
	 assign data_writeReg = wire_reg;
	 
	 //jump_all
	 wire [11:0]wire_jp;
	 wire s_bex,s_j,s_j1,s_j2;
	 wire [11:0]wire_pc,wire_pc2,wire_addaddress;
	 
	 and and_bex2(s_bex,ctrl_out[11],isnote);
	 p_mux12 mux_bex2(.a(wire_jp),.b(q_imem[11:0]),.s(s_bex),.out(wire_pc));
	 p_mux12_4 mux_jp(.a(wire_pc2),.b(q_imem[11:0]),.c(data_readRegB[11:0]),.d(/*...*/),.s0(ctrl_out[6]),.s1(ctrl_out[5]),.out(wire_jp));
	 p_mux12 mux_j(.a(d),.b(wire_addaddress),.s(s_j),.out(wire_pc2));
	 or or_j(s_j,s_j1,s_j2);
	 and and_br(s_j1,ctrl_out[4],isnote);
	 and and_blt(s_j2,ctrl_out[10],~lessthan,isnote);
	 p_RCA_12b adder_jp(.x(d),.y(q_imem[11:0]),.s(wire_addaddress));
	 
endmodule
