module mux4to1 (W0, W1, W2, W3, s, f);

	input W0, W1, W2, W3;
	input [1:0] s;
	output f;
	reg f;
	
	always@(W0 or W1 or W2 or W3 or s) begin
		case(s)
			2'b00 : f = W0;
			2'b01 : f = W1;
			2'b10 : f = W2;
			2'b11 : f = W3;
		endcase
	end	
endmodule