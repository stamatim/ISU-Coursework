
module lab7step1(Cin, X, Y, S, Cout); // verilog implementation for full adder
	
	input X, Y, Cin;
	output Cout, S;
	
	assign S = (X ^ Y ^ Cin);
	
	assign Cout = (~X && Cin && Y)|(Cin && ~Y && X)|(X && Y && ~Cin)|(Cin && X && Y);

endmodule