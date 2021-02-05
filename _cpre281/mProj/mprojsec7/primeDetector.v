module primeDetector (P,W,X,Y,Z);
	input W,X,Y,Z;
	output P;
	
	assign P = (~W & ~X & Y)|(~W & X & Z)|(~X & Y & Z)|(X & ~Y & Z);
	
endmodule	