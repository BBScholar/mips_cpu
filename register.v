


module register(clk, d, write, q);
	parameter width = 32;
	
	input wire [width - 1:0] d;
	input write, clk;
	
	output reg [width - 1:0] q;
	
	reg [width - 1:0] internal;
	
	// write internal register to output on positive edge
	always @ (posedge clk) begin
		q <= internal;
	end
	
	// on negative edge of the clock,write the data to the internal register
	// 
	always @ (negedge clk) begin
		if(write)
			internal <= d;
	end

endmodule