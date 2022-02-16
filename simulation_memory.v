

module sim_memory(clk, address, write, read_data, write_data);
	localparam memory_size = 'h800000;

	input clk, write;
	input [31:0] address, write_data;
	
	output reg [31:0] read_data;
	
	wire [31:0] word_address;
	assign word_address = address >> 2;
	
	integer i;
	reg [31:0] memory[0:memory_size - 1];
	
	initial begin
		memory[0] = 1;
		for(i = 0; i < memory_size; i = i + 1)
			memory[i] <= 0;
	end
	
	always @ (posedge clk) begin
		if(write) begin
			memory[word_address] <= write_data;
		end else begin
			read_data <= memory[word_address];
		end
	end

endmodule