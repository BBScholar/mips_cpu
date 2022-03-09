


// handles logic surrounding memory access
module memory_interface(
	clk, 
	write, pc, data_address, write_data,  // inputs from cpu
	instruction, read_data,               // outputs to cpu
	sel_address, sel_data, sel_write,     // outputs to mem
	raw_read_data                         // inputs from mem
);
	localparam width = 32;
	
	input clk;
	
	input write;
	input [31:0] pc, data_address, write_data;
	
	output reg [31:0] instruction, read_data;
	
	input [31:0] raw_read_data;
	output sel_write;
	output wire [31:0] sel_address, sel_data;
	
	// input logic
	assign sel_write = write & !clk;
	
	mux2x1 address_sel_mux(
		.a(pc),
		.b(data_address),
		.s(!clk),
		.out(sel_address),
	);

	//load_data_unit lu();
	// store_data_unit su();

endmodule

/*
module load_data_unit(data_in, data_out, address, byte, half, is_unsigned);
	
	input byte, half, is_unsgined;
	input [31:0] data_in, address;
	
	output [31:0] data_out;
	
	wire word;
	wire [1:0] byte_address;
	wire half_address;
	
	assign word = !byte & !half;
	assign byte_address = address[1:0];
	assign half_address = address[1];
	
	wire [7:0]  byte_selected;
	wire [15:0] half_selected;
	wire [31:0] byte_signed, byte_result, half_signed, half_result;


	mux4x1 #(.data_width(8)) byte_selection(
		.a(data_in[31:24]),
		.b(data_in[23:16]),
		.c(data_in[15:8]),
		.d(data_in[7:0]),
		.s(byte_address),
		.out(byte_selected)
	);
	
	
	sign_extend #(.in_width(8), .out_width(32)) byte_extend(
		.in(byte_selected),
		.out(byte_signed)
	);
	
	mux2x1 byte_sign_select(
		.a(byte_signed),
		.b({{24{1'b0}}, byte_selected}),
		.s(is_unsigned),
		.out(byte_result)
	);
	
	
	//Half word selection logic
	mux2x1 #(.data_width(16)) half_selection(
		.a(data_in[31:16]),
		.b(data_in[15:0]),
		.s(byte_address),
		.out(half_selected)
	);
	
	sign_extend #(.in_width(16), .out_width(32)) half_extend(
		.in(half_selected),
		.out(half_signed)
	);
	
	mux2x1 half_sign_select(
		.a(half_signed),
		.b({{16{1'b0}}, half_selected}),
		.s(is_unsigned),
		.out(half_result),
	);
	
	
	// output logic
	mux4x1 output_mux(
		.a(byte_result),
		.b(half_result),
		.c(data_in),
		.d(data_in),
		.s({half, word}),
		.out(data_out)
	);
	
	
endmodule

module store_data_unit(data_in, data_out, address, byte, word);

	

endmodule
*/
