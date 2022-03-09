

module comparitor(
	a, b, is_unsigned,
	lt, eq, neq, gt, lte, gte
);
	parameter width = 32;

	input is_unsigned;	
	input [width-1:0] a,b;

	output wire eq, neq;
	output wire lt, gt, lte, gte;

	assign eq = (a == b);
	assign neq = !eq;

	assign lt = (($unsigned(a) < $unsigned(b)) & is_unsigned) | (($signed(a) < $signed(b)) & !is_unsigned);
	assign gt = !lt & !eq;

	assign lte = !gt;
	assign gte = !lt;

endmodule