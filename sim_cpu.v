`timescale 1ns/1ps

module sim_cpu;
	reg mem_clk;
	reg rst;
	
	wire mem_write;
	wire [31:0] mem_address, mem_write_data, mem_read_data;
	
	cpu cpu(
		.clk(mem_clk),
		.rst(rst),
		.mem_write(mem_write),
		.mem_address(mem_address),
		.mem_read_data(mem_read_data),
		.mem_write_data(mem_write_data)
	);
	
	sim_memory mem(
		.clk(mem_clk),
		.address(mem_address),
		.write(mem_write),
		.write_data(mem_write_data),
		.read_data(mem_read_data)
	);
	
	initial begin
		mem_clk = 0;
		rst = 0;
		#20 rst = 1;
	end
	
	always begin
		#10 mem_clk = !mem_clk;
	end
	

endmodule