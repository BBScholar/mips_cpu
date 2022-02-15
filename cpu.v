
module cpu(clk);
	localparam width = 32;
	localparam double_width = 64;
	
	// clk input
	input clk;
	
	// generate slowly clock
	wire slow_clk;
	
	always @ (posedge clk) slow_clk = !slow_clk;
	
	// register nets
	wire [31:0] pc_out;
	
	wire [63:0] hilo_out;
	wire [31:0] hi_out, lo_out;
	
	// 32 bit program counter
	register #(.width(32)) pc_register(
		.clk(clk),
		.d(),
		.write(1'b1),
		.q(pc_out)
	);
	
	// exception handling registers
	// ignore for now
	register #(.width(32)) epc_register();
	register #(.width(32)) cause_register();
	
	// double wide register for mult/div operations
	hilo hilo_register(
		.clk(clk),
		.d(),
		.write(),
		.q(hilo_out)
	);
	
	assign hi_out = hilo_out[63:32];
	assign lo_out = hilo_out[31: 0];
	
	// current instruction
	wire [width - 1:0] instruction;
	
	// derivatives of instruction
	wire [5:0] opcode, funct;
	wire [4:0] rs, rt, rd, shamt;
	wire [15:0] immediate_value;
	wire [25:0] jump_value;
	
	assign {opcode, rs, rt, rd, shamt, funct} = instruction;
	
	assign immediate_value = instruction[15:0];
	assign jump_value = instruction[25:0];
	
	// calculate immediate values
	wire [width - 1:0] immediate_extended;
	wire [width - 1:0] immediate_extended_shifted;
	
	sign_extend immediate_sign_extender(.in(immediate_value), .out(immediate_extended));
	
	assign immediate_extended_shifted = {{immediate_extended[29:0]}, {2'b00}};
	
	// calculate jump values
	wire [27:0] jump_shifted;
	wire [31:0] jump_final;
	
	assign jump_shifted = {jump_value, 2'b00};
	assign jump_final   = {pc_out[31:28], jump_shifted};
	
	// program counter path
	wire [31:0] pc_p4, pc_p4_pimm, pc_paths[0:5];
	
	adder pc_adder1(.a(pc_out), .b(32'b100), .out(pc_p4));
	adder pc_adder2(.a(pc_p4), .b(immediate_extended_shifted), .out(pc_p4_pimm) );
	
	// branching mux
	mux2x1 pc_mux1(
		.a(pc_p4),
		.b(pc_p4_pimm),
		.s(), // TODO: branch here
		.out(pc_paths[0])
	);
	
	// jump mux
	mux2x1 pc_mux2(
		.a(pc_paths[0]),
		.b(jump_final),
		.s(), // TODO: jump here
		.out(pc_paths[1])
	);
	
	// jump register mux
	mux2x1 pc_mux3();
	
	// overflow exception mux
	mux2x1 pc_mux4(
		.a(),
		.b(),
		.s(),
		.out()
	);
	
	//
	mux2x1 pc_mux5();
	
	
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
	
	mux4x1 #(.data_width(32)) write_data_selector(
		.a(lo_out),
		.b(hi_out),
		.c(), // output of alu
		.d(), // output of memory reads
		.s(), // cpu control
		.out()
	);
	
	mux4x1 #(.data_width(32)) write_reg_selector(
		.a(),
		.b(),
		.c(),
		.d(),
		.s(),
		.out()
	);
	
	register_file register_file(
		.clk(clk),
		.read_reg1(rs),
		.read_reg2(rt),
		.write_reg(),
		.write(), // cpu control
		.write_data()
	);
	
	// ========== Data Manipulation =================
	// ALU and barrel shifter
	barrel_shifter shifter();
	ALU alu();
	comparitor compare();
	
	
	// ========== Memory Read/Write =================
	

endmodule