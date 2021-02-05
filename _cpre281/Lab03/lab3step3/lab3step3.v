module lab3step3 (A, F, C, G, W);

	input F, C, G, W; // Inputs: Farmer, Cabbage, Goat, Wolf
	output A; // Output: Alarm (on/off)
	
	assign A = ((~F & G & W)|(F & ~C & ~G)|(~F & C & G & ~W)|(F & C & ~G & ~W));

endmodule