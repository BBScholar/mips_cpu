
module priority_encoder(inputs, outputs, none);
	
	parameter output_lines = 2;
	
	localparam input_lines = 2**output_lines;
	
	input wire [input_lines  - 1:0] inputs;
	output wire none;
	output reg [output_lines - 1:0] outputs;
	
	// local variables
	wire [input_lines - 1:0] priority_inputs;
	
	// assignments
	assign none = !(|inputs);
	assign priority_inputs[0] = inputs[0];

	
	genvar i;
	generate
		for(i = 1; i < input_lines; i = i + 1) begin : encoder_input_gen
			assign priority_inputs[i] = inputs[i] & !(|inputs[i - 1:0]);
		end
		
		// case(priority_inputs)
			
			//default: outputs <= 0;
		//endcase
	endgenerate
	
	always @inputs begin
		// output = 0;
		//  for(
		
	end

endmodule