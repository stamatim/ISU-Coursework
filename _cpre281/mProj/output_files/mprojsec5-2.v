module mprojsec5-2 (B, W, X, Y, Z);
	input W, X, Y, Z;
	output B;
	
	assign P = (X & ~Y & Z)|(W & Y & Z)|(~W & ~X & Y & ~Z);
	
endmodule