

module comparitor(a, b, lt, eq, neq, gt, lte, gte);
	parameter width = 32;
	
	input [width-1:0] a,b;
	
	output wire lt, neq, eq, gt, lte, gte;
	
	assign lt = (a < b);
	assign eq = (a == b);
	assign gt = (a > b);
	
	assign neq = !eq;
	
	assign lte = lt & eq;
	assign gte = gt & eq;
	
endmodule