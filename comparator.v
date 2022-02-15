

module comparitor(a, b, lt, eq, gt, lte, gte);

	parameter width = 32;
	
	input [width-1:0] a,b;
	
	output reg lt, eq, gt, lte, gte;

	
endmodule