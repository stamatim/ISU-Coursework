module lab3step1 (A, C, G, W);
	
	// Name the inputs and outputs
	input C,G,W;
	output A;
	
	// Logic for first 'and' condition
	not(D, C); 
	not(X, W);
	or(L, D, G, X);
	
	// Logic for second 'and' condition
	not(H, G);
	or(R, C, H, W);
	
	// Store the result in the output variable
	and(A, L, R);

endmodule