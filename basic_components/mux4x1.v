

module mux4x1
(
	a, b, c, d, s,out
);
	parameter data_width = 32;

	input wire [data_width - 1:0] a, b, c, d;
	input wire [1:0] s;
	
	output wire [data_width - 1:0] out;
	
	// local variables
	wire [data_width - 1:0] m1, m2;
	
	mux2x1  #(.data_width(data_width)) mux1 (
		.a(a),
		.b(b),
		.s(s[0]),
		.out(m1)
	);
	
	mux2x1  #(.data_width(data_width)) mux2 (
		.a(c),
		.b(d),
		.s(s[0]),
		.out(m2)
	);
	
	mux2x1  #(.data_width(data_width)) mux3 (
		.a(m1),
		.b(m2),
		.s(s[1]),
		.out(out)
	);


endmodule