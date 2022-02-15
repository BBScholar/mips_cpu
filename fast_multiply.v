
module fast_mult(clk, a, b, out);
	parameter width = 32;
	
	//io
	input clk;
	input [width - 1:0] a, b;
	
	output [2 * width - 1:0] out;
	
	// local nets
	wire [width - 1: 0] inputs[0:width - 1];
	wire [width - 1:0]  layer1[0:(width / 2) - 1];
	wire [width - 1:0]  layer2[0:(width / 4) - 1];
	wire [width - 1:0]  layer3[0:(width / 8) - 1];
	wire [width - 1:0]  layer4[0:(width / 16) - 1];
	
	// output assignemnts
	assign out[0] = inputs[0][0];
	assign out[1] = layer1[0][0];
	assign out[2] = layer2[0][0];
	
	
	assign out[63] = inputs[31][31];
	

	// layer 1 adders
	genvar i;
	generate
	
		// generate inputs
		for(i = 0; i < width; i = i + 1) begin : layer0_gen
			assign inputs[i] = a & {width{b[i]}};
		end
		
		// 16 adders
		for(i = 0; i < width; i = i + 2) begin : layer1_gen
			adder inst(
				.clk(clk),
				.a(inputs[i + 0]),
				.b(inputs[i + 1]),
				.out(layer1[i / 2])
			);
		end
		
		// 8 adders
		for(i = 0; i < 16; i = i + 2) begin : layer2_gen
			adder inst(
				.clk(clk),
				.a(layer1[i + 0]),
				.b(layer1[i + 1]),
				.out(layer2[i/2])
			);
		end
		
		// 4 adders
		for(i = 0; i < 8; i = i + 2) begin : layer3_gen
			adder inst(
				.clk(clk),
				.a(layer2[i + 0]),
				.b(layer2[i + 1]),
				.out(layer3[i/2])
			);
		end
		
		// 2 adders
		for(i = 0; i < 4; i = i + 2) begin : layer4_gen
			adder inst(
				.clk(clk),
				.a(layer3[i + 0]),
				.b(layer3[i + 1]),
				.out(layer4[i/2])
			);
		end
		
	endgenerate
	
	adder final_adder(
		.clk(clk),
		.a(layer4[0]),
		.b(layer4[1]),
		.out(out[47:16])
	);

endmodule