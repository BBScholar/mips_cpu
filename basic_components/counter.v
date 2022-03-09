

module counter(clk, rst, up, out, wrap);
	parameter BITS=32;
	
	input wire clk, rst, up;
	output reg [BITS - 1:0] out, wrap;
		
	always @ (posedge clk) begin
		if(!rst)
			out <= 0;
		else begin
			if(up) begin
				out <= out + 1;
				wrap <= &out;
			end else begin
				out <= out - 1;
				wrap <= !(|out);
			end
		end
	end
	
endmodule