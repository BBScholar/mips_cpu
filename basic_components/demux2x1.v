

// latching demux
module demux2x1(in, s, out_a, out_b);
	parameter width = 32;
	
	input s;
	input [width - 1:0] in;
	
	// should these just latch?
	output reg [width - 1:0] out_a, out_b;
	
	always @(in, s) begin
		if(s)
			out_b <= in;
		else
			out_a <= in;
	end
	
endmodule