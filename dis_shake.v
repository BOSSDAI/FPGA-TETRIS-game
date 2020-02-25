//`define UD #1

module dis_shake(
     input key_in,
     output key_value
     );

// inner signal
reg count;

//内部信号
always @(posedge key_in)
    //key_in_r<= `UD {key_in_r[0],key_in};
	if(count == 0)begin
		count <= 0;
	end
	else
	count <= count+1;

assign key_value = count;
endmodule
