module lab3step2 (A, C, G, W);
	input C, G, W; // The Cabbage, Goat, and Wolf as inputs
	output A; // The Alarm as the output
	
	assign A = ((~C|G|~W)&(C|~G|W)); // The logic expression in POS format for this circuit

endmodule