
// source: https://www.researchgate.net/publication/228463169_Design_of_a_reversible_bidirectional_barrel_shifter
module barrel_shifter(
	in, shift, left, logical, out
);
	parameter shift_layers = 5;
	
	localparam width = 2**shift_layers;
	localparam mux_width = 1;
	
	// input/output
	input wire [width - 1:0] in;
	input wire [shift_layers - 1 : 0] shift;
	input wire left, logical;
	
	output [width - 1:0] out;
	
	// local variables
	wire fill_sign, sign;
	wire [width - 1:0] layer_io[0:shift_layers];
	
	//
	assign sign = in[width - 1];
	assign fill_sign = (!logical & !left & sign);
	
	// data reversal control unit 1
	data_reverser #(.data_width(width)) rerverser1(
		.in(in),
		.reverse(!left),
		.out(layer_io[0])
	);
	
	// data reversal control unit 2
	data_reverser #(.data_width(width)) rerverser2(
		.in(layer_io[shift_layers]),
		.reverse(!left),
		.out(out)
	);
	
	genvar i, j;
	generate
		
		for(i = 0; i < shift_layers; i = i + 1) begin : shifter_gen_outer
			for(j = 0; j < width; j = j + 1) begin : shifter_gen_inner
				wire temp;
				
				if(i > 2**i)
					assign temp = layer_io[i][j - 2**i];
				else
					assign temp = fill_sign;
				
				mux2x1 #(.data_width(1)) inst(
					.a(layer_io[i][j]),
					.b(temp),
					.s(shift[i]),
					.out(layer_io[i + 1][j])
				);
			
			end
		end
		
	endgenerate
	

endmodule