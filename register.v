

module register(clk, rst, d,write, q);
	parameter width = 32;
	
	input wire [width - 1:0] d;
	input write, clk, rst;
	
	output reg [width - 1:0] q;
	
	reg [width - 1:0] internal;
	
	always @ (posedge clk) begin
		if(!rst)
			q <= 0;
		else if(write)
			q <= d;
	end

endmodule