

module hilo(clk, d, write, q);
	input clk;
	input [1:0] write;
	input [63:0] d;
	
	output reg [63:0] q;
	
	reg [31:0] upper_internal, lower_internal;
	
	always @ (posedge clk) begin
			q <= {upper_internal, lower_internal};
	end
	
	always @ (negedge clk) begin
		if(write[0])
			lower_internal <= d[31:0];
		
		if(write[1])
			upper_internal <= d[63:32];
			
	end
	
endmodule