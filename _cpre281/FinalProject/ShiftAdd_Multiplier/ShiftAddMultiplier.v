module ShiftAddMultiplier(Q, N, M, Clk);

	input Clk; // Input for the clock
	input signed [7..0] N; // Input for the Multiplier
	input signed [7..0] M; // Input for the Multiplicand
	
	output reg [15..0] Q; // The product that will be the output
	
	reg signed [16..0] P; // Upper result, lower result, and extra P-1 bit
	
endmodule