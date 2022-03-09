
module sign_extend
(
	in, out
);
	parameter in_width = 16;
	parameter out_width = 32;
	
	localparam diff = out_width - in_width;
	
	input wire [in_width - 1:0] in;
	
	output [out_width - 1:0] out;
	
	assign out = {{diff{in[in_width - 1]}}, in};
	
endmodule