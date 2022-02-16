

module hilo(clk, rst, d, write, q);
	
	input clk,rst;
	input [1:0] write;
	input [63:0] d;
	
	output [63:0] q;
	
	// internal nets
	wire [31:0] d_upper, d_lower;
	wire [63:0] d_final;
	
	assign d_upper = d[63:32];
	assign d_lower = d[31:0];
	
	mux2x1 upper_mux(
		.a(q[63:32]),
		.b(d_upper),
		.s(write[1]),
		.out(d_final[63:32])
	);
	
	mux2x1 lower_mux(
		.a(q[31:0]),
		.b(d_lower),
		.s(write[0]),
		.out(d_final[31:0])
	);
	
	register #(.width(64)) internal_register(
		.clk(clk),
		.rst(rst),
		.d(d_final),
		.write(|write),
		.q(q)
	);
	
endmodule