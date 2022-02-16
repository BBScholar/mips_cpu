
// simple adder for places that do not need a full alu
module adder(a, b, out, zero, overflow);
	parameter width = 32;

	input [width - 1: 0] a, b;
	
	output reg [width - 1:0] out;
	output zero;
	output reg overflow;
	
	assign zero = (out == 0);
	always @ (a, b)
	begin
		{overflow, out} = a + b;
	end
	
endmodule