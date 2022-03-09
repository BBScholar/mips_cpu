
module cpu(clk, rst, mem_write, mem_address, mem_write_data, mem_read_data);
	localparam width = 32;
	localparam double_width = 64;
	
	// ============== IO definitions ==============
	input clk, rst;
	input [width - 1:0] mem_read_data;
	
	output mem_write;
	output [width - 1:0] mem_address, mem_write_data;
	
	// ============== Internal Net List ==============
	
	// inverted clock signal
	wire n_clk;
	
	wire [31:0] pc_in, pc_out;
	
	wire [63:0] hilo_in, hilo_out;
	wire [31:0] hi_out, lo_out;
	
	// current instruction
	wire [width - 1:0] instruction;
	
	// derivatives of instruction;
	wire [5:0] opcode, funct;
	wire [4:0] rs, rt, rd, shamt;
	wire [15:0] immediate_value;
	wire [25:0] jump_value;
	
	wire [width - 1:0] immediate_sign_extended_shifted;

	wire [27:0] jump_shifted;
	wire [31:0] jump_final;
	
	wire [31:0] pc_p4, pc_p4_pimm, pc_paths[0:5];
	
	// ============== Net Assignements ==============
	assign n_clk = !clk;
	
	assign hi_out = hilo_out[63:32];
	assign lo_out = hilo_out[31:0];
	
	assign {opcode, rs, rt, rd, shamt, funct} = instruction;
	assign immediate_value = instruction[15:0];
	assign jump_value = instruction[25:0];

	assign jump_shifted = {jump_value, 2'b00};
	assign jump_final   = {pc_out[31:28], jump_shifted};
	
	// ============== Modules ==============

	
	// 32 bit program counter
	register #(.width(32)) pc_register(
		.clk(clk),
		.rst(rst),
		.d(pc_in),
		.write(1'b1), // written on every cycle
		.q(pc_out)
	);
	
	// exception handling registers
	// ignore for now
	// register #(.width(32)) epc_register();
	// register #(.width(32)) cause_register();
	
	// double wide register for mult/div operations
	hilo hilo_register(
		.clk(clk),
		.d(hilo_in),
		.write(2'b0),
		.q(hilo_out)
	);
	
	adder pc_adder1(.a(pc_out), .b(32'b100), .out(pc_p4));
	adder pc_adder2(.a(pc_p4), .b(immediate_sign_extended_shifted), .out(pc_p4_pimm) );
	
	// branching mux
	mux2x1 pc_mux1(
		.a(pc_p4),
		.b(pc_p4_pimm),
		.s(0), // TODO: branch here
		.out(pc_paths[0])
	);
	
	// jump mux
	mux2x1 pc_mux2(
		.a(pc_paths[0]),
		.b(jump_final),
		.s(0), // TODO: jump here
		.out(pc_paths[1])
	);
	
	// jump register mux
	mux2x1 pc_mux3(
		.a(pc_paths[1]),
		.b(register1_data), // TODO: fix this
		.s(0), // TODO: implement thos
		.out(pc_paths[2])
	);
	
	// overflow exception mux
	mux2x1 pc_mux4(
		.a(pc_paths[2]),
		.b(32'h8000_0180),
		.s(0), // TODO: handle this
		.out(pc_paths[3])
	);
	
	// invalid opcode mux
	mux2x1 pc_mux5(
		.a(pc_paths[3]),
		.b(32'h8000_000),
		.s(0), // TODO: handle this
		.out(pc_paths[4])
	);
	
	// trap jump mux
	mux2x1 pc_mux6(
		.a(pc_paths[4]),
		.b(32'h0000_0000), // TODO: edit this
		.s(0), // TODO: handle this
		.out(pc_in)
	);

	// ========== Memory Load/Store ================

	wire [31:0] imm_to_alu;

	immediate_logic imm_logic(
		.raw_immediate(immediate_value),
		.alu_signed(0), // TODO: control line
		.load_upper(0), // TODO: control line
		.sign_extended_shifted(immediate_sign_extended_shifted),
		.to_alu(imm_to_alu)
	);
		
	// ========== Memory Load/Store ================
	
	memory_interface mem_iface(
		
	);
	
	// ========== Register file stuff ================
	// read_reg2 sources
	// 1. 
	//
	// write data sources
	// 1. alu operation
	// 2. memory (after alu operation)
	// 3. hi register
	// 4. lo register
	//
	// write_reg sources
	// 1. rt
	// 2. rd
	// 3. 0'b1_1111 (link register)
	
	wire [31:0] register1_data, register2_data;

	mux4x1 #(.data_width(32)) write_data_selector(
		.a(lo_out),
		.b(hi_out),
		.c(), // output of alu
		.d(pc_p4), // output of memory reads
		.s(), // cpu control
		.out()
	);
	
	mux4x1 #(.data_width(32)) write_reg_selector(
		.a(rd),
		.b(rs),
		.c(),
		.d(5'b1_1111), // link register
		.s(),
		.out()
	);
	
	register_file register_file(
		.clk(clk),
		.rst(rst),
		.read_reg1(rs),
		.read_reg2(rt),
		.read_data1(register1_data),
		.read_data2(register2_data),
		.write_reg(rd),
		.write(0), // cpu control
		.write_data(32'b0)
	);
	
	// ========== Data Manipulation =================
	// ALU and barrel shifter
	wire [31:0] alu_result, lt_result;
	wire compare_eq, compare_neq, compare_lt, compare_lte, compare_gt, compare_gte;
	
	// used for slt class instructions
	assign lt_result = {31'b0, compare_lt};

	alu_logic alu(
		.reg1_data(register_data1),
		.reg2_data(register_data2),
		.immediate_data(imm_to_alu),
		.use_immediate(), // control line
		.shift_ammount(shamt),
		.shift_type(), // control line
		.result(alu_result)
	);

	comparitor compare(
		.a(alu_result),
		.b(32'b0),
		.eq(compare_eq),
		.neq(compare_neq),
		.lt(compare_lt),
		.lte(compare_lte),
		.gt(compare_gt),
		.gte(compare_gte)
	);

	mux2x1 

	// branch logic


endmodule