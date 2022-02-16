

module ALU(clk, a, b, ctl, out, zero, overflow);
	parameter size = 32;
	
	input clk;
	input wire [size - 1:0] a, b;
	input wire [3:0] ctl;
	
	output reg [size - 1:0] out;
	output zero, overflow;
	
	assign zero = (out == 0);
	assign overflow = 0;
	
	always @ (a or b or ctl) // we can change this later, not sure what I need
	begin
			case  (ctl)
				0: out <= a & b;
				1: out <= a | b;
				2: out <= a + b;
				6: out <= a - b;
				7: out <= a < b ? 1 : 0;
				12: out <= !(a | b);
				default: out <= 0;
			endcase
	end
	

endmodule