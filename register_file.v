
module register_file(clk, rst, read_reg1, read_reg2, write_reg, write, write_data, read_data1, read_data2);
	localparam width = 32;
	localparam num_registers = 32;
	localparam select_width = 5;

	input [select_width - 1:0] read_reg1, read_reg2, write_reg;
	input [width-1:0] write_data;
	input clk, write, rst;
	
	output reg [width - 1:0] read_data1, read_data2;
	
	// integer for looping over registers
	integer i;
	
	// register file
	reg [width - 1:0] registers[0:num_registers-1];
	
	// basically just a bunch of muxes
	always @ (read_reg1,read_reg2) begin
		read_data1 <= registers[read_reg1];
		read_data2 <= registers[read_reg2];
	end
	
	// write and reset behavior
	always @ (posedge clk) begin
		// register 0 is always equal to 0
		registers[0] <= 0;
		
		if(!rst) begin
			for(i = 0; i < num_registers; i = i + 1) begin
				registers[i] <= 0;
			end
		end else if(write & (write_reg != 0)) begin
			registers[write_reg] <= write_data;
		end
	end


endmodule