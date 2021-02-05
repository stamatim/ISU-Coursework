module mprojsec6 (P, W, X, Y, Z);

	input W, X, Y, Z;
	output P;
	
	assign P = (~W & ~X) | (W & ~Z) | (~W & X & Z);
	
endmodule	