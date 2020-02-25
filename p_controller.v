module p_controller(opcoder,out);
input [4:0]opcoder;
output [15:0]out;//[0]Rwe,[1]Rdst,[2]ALUinB,[3]DMem,[4]BR,[5]JP1,[6]JP0,[7]Rwd1,[8]Rwd0,[9]jal,
          //[10]blt,[11]bex,[12]setx,[13]aluop,[14]add.sub,[15]addi
wire [31:0] de;

p_decoder decoder1(opcoder,de);

//Rwe
or Rwe(out[0],de[0],de[5],de[8],de[3],de[21]);
//Rdst
or Rdst(out[1],de[0],de[8],de[1],de[3]);
//ALUinB
or ALUinB(out[2],de[5],de[7],de[8]);
//DMem
assign out[3] = de[7];
//BR
assign out[4] = de[2];
//JP1
assign out[5] = de[4];
//JP0
or JP0(out[6],de[1],de[3]);
//Rw1
or Rwd1(out[7],de[8],de[21]);
//Rw0
or Rwd0(out[8],de[3],de[21]);
//jal
assign out[9] = de[3];
//blt
assign out[10] = de[6];
//bex
assign out[11] = de[22];
//setx
assign out[12] = de[21];
//aluop
or aluop(out[13],de[5],de[7],de[8]);
//
assign out[14] = de[0];
assign out[15] = de[5];

endmodule