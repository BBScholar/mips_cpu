
// decodes the current instruction and controls other hardware
module cpu_control(
	clk, opcode, reg_dst, branch, mem_read, mem_write, mem_to_reg, alu_op, alu_src, reg_write,
	int_op, float_op
);
	
	input clk;
	input wire [5:0] opcode;
		
	
	output reg_dst, branch, mem_read, mem_write, mem_to_reg, alu_op, alu_src, reg_write, int_op, float_op;
	
	always @ (posedge clk)
	begin
		case (opcode)
			0 : begin
			
			end
			2: begin // j
			
			end
			3: begin // jal
			
			end
			4: begin
			
			end
			
		
		endcase
	end

endmodule