
module register_file(clk, read_reg1, read_reg2, write_reg, write, write_data, read_data1, read_data2);
	localparam width = 32;
	localparam num_registers = 32;
	localparam select_width = 5;

	input [select_width - 1:0] read_reg1, read_reg2, write_reg, write_data;
	input clk, write;
	
	output reg [width - 1:0] read_data1, read_data2;
	
	
	// register file
	reg [width - 1:0] registers[0:num_registers-1];
	

	always @ (posedge clk)
	begin
		registers[0] = 0;
		read_data1 <= registers[read_reg1];
		read_data2 <= registers[read_reg2];
	end
	
	always @ (negedge clk)
	begin
		if(write)
		begin
			if(write_reg == 0)
				registers[write_reg] <= write_data;
		end
	end


endmodule