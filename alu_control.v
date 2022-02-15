

module alu_control(clk, alu_op, func, alu_ctl);

	input clk, alu_op;
	input [5:0] func;
	
	output reg [3:0] alu_ctl;
	
	always @ (posedge clk)
	begin
	
	end

endmodule