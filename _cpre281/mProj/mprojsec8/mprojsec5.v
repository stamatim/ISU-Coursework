module mprojsec5 (B, W, X, Y, Z);
	input W, X, Y, Z;
	output B;
	
	assign B = (X & ~Y & Z)|(W & Y & Z)|(~W & ~X & Y & ~Z);
	
endmodule