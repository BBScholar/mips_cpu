
module load_unit(address, read_data, byte, half, is_unsigned, out);
	
	input byte, half, is_unsigned;
	input [31:0] address, read_data;
	
	output [31:0] out;
	
	// internal wires
	wire word;
	wire [1:0] byte_offset;
	wire half_offset;
	wire [7:0] 	byte_out;
	wire [15:0] half_out;
	wire [31:0] byte_unsigned, byte_signed, half_unsigned, half_signed;
	wire [31:0] byte_result, half_result;
	
	// assignments
	assign word = !byte & !half;
	
	assign byte_offset = address[1:0];
	assign half_offset = address[1];
	
	assign byte_unsigned = {24'b0, byte_out};
	assign half_unsigned = {16'b0, half_out};
	
	// byte loads
	mux4x1 #(.data_width(8)) byte_selector(
		.a(read_data[7:0]),
		.b(read_data[15:8]),
		.c(read_data[23:16]),
		.d(read_data[31:24]),
		.s(byte_offset),
		.out(byte_out)
	);
	
	sign_extend #(.in_width(8), .out_width(32)) byte_extender(
		.in(byte_out),
		.out(byte_signed)
	);
	
	mux2x1 byte_sign_selector(
		.a(byte_signed),
		.b(byte_unsigned),
		.s(is_unsigned),
		.out(byte_result)
	);
	
	// half loads
	mux2x1 #(.data_width(16)) half_selector(
		.a(read_data[15:0]),
		.b(read_data[31:16]),
		.s(half_offset),
		.out(half_out)
	);
	
	sign_extend #(.in_width(16), .out_width(32)) half_extender(
		.in(half_out),
		.out(half_signed)
	);

	mux2x1 half_sign_selector(
		.a(half_signed),
		.b(half_unsigned),
		.s(is_unsigned),
		.out(half_result)
	);
	
	// final selection
	mux4x1 result_mux(
		.a(byte),
		.b(read_data),
		.c(half),
		.d(read_data),
		.s({half,word}),
		.out(out)
	);

endmodule

module store_unit(address, read_data, write_data, byte, half, out);
	
	input wire byte, half;
	input [31:0] address, write_data, read_data;
	
	output [31:0] out;
	
	// local variables
	wire word, half_offset;
	wire [1:0] byte_offset;
	wire [7:0] byte_data;
	wire [15:0] half_data;
	wire [31:0] half_out, byte_out;
	
	// assignments
	assign word = !byte & !half;
	
	assign byte_offset = address[1:0];
	assign half_offset = address[1];
	
	assign byte_data = write_data[7:0];
	assign half_data = write_data[15:0];
	
	mux4x1 byte_selector(
		.a({read_data[31: 8], byte_data}),
		.b({read_data[31:16], byte_data, read_data[7:0]}),
		.c({read_data[31:24], byte_data, read_data[15:0]}),
		.d({byte_data, read_data[23:0]}),
		.s(byte_offset),
		.out(byte_out)
	);
	
	mux2x1 half_selector(
		.a({read_data[31:16], half_data}),
		.b({half_data, read_data[15:0]}),
		.s(half_offset),
		.out(half_out)
	);
	
	mux4x1 result_mux(
		.a(byte_out),
		.b(write_data),
		.c(half_out),
		.d(write_data),
		.s({half, word}),
		.out(out)
	);
	
endmodule