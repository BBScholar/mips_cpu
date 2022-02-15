


module data_reverser(in, out, reverse);
	parameter data_width = 32;
	
	input [data_width - 1:0] in;
	input reverse;
	
	output [data_width - 1:0] out;
	
	genvar i;
	generate
		// in case data_width is odd for some reason
		if(data_width % 2)
			assign out[(data_width / 2) + 1] = in[(data_width / 2) + 1];
	
		for(i = 0; i < (data_width/2); i = i + 1) begin : reverser_gen
			mux2x1 #(.data_width(1)) left(
				.a(in[i]),
				.b(in[data_width - 1 - i]),
				.s(reverse),
				.out(out[i])
			);
			
			mux2x1 #(.data_width(1)) right(
				.a(in[data_width - 1 - i]),
				.b(in[i]),
				.s(reverse),
				.out(out[data_width - 1 - i])
			);
		end
	endgenerate
	
	
endmodule