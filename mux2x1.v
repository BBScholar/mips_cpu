
module mux2x1
(
	a, b, s, out
);
	parameter data_width = 32;
	
	input wire [data_width - 1:0] a, b;
	input wire s;
	
	output wire [data_width - 1:0] out;
	
	wire [data_width - 1:0] result1, result2, result3;

	// assign out = result3;
	
	// if s == 0, return a
	// else return b
	genvar i;
	generate 
		for(i = 0; i < data_width; i = i + 1) begin : mux_gen
			and and1(result1[i], a[i], !s);
			and and2(result2[i], b[i],  s);
			or or1(out[i], result1[i], result2[i]);
		end
	endgenerate

endmodule