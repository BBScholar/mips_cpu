
module mul_div_new(
	clk, a, b, sel, out
);

	parameter width=32;

	input clk, sel;
	input [width-1:0] a, b;
	output reg [2*width - 1:0] out;


endmodule

module mul_div(
	clk, mult, s, a, b, hilo
);
	// parameters
	parameter width = 32;
	
	// ==== io =====
	input clk, mult, s;
	input [width  - 1:0] a, b;
	output reg [width * 2 - 1:0] hilo;
	
	// local modules
	
	
	// local data
	reg [width - 1:0] multiplicand_divisor;
	reg [2 * width - 1:0] product;
	wire a_pos, b_pos, out_sign;
	
	integer i;
	
	// static assignments
	assign a_pos = a[width - 1] == 0;
	assign b_pos = b[width - 1] == 0;
	assign out_sign = a_pos | b_pos;
	
	always @ (posedge clk)
	begin	
		if(mult)
		begin
			hilo = {b, 32'b0};
			
			for(i = 0; i < 32; i = i + 1)
			begin
				if(hilo[0])
					hilo[63:32] = hilo[63:32] + a;
				hilo = hilo >> 1;
			end
	
		end
		else
		begin
			hilo = {32'b0, a};
			
			for(i = 0; i < 33; i = i + 1)
			begin
				hilo = a *b;
			end
		end
		
	end
	

endmodule