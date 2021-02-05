module Output_logic (Q1, Q0, A, B, C);
	input Q1, Q0;
	output A, B, C;
	reg A, B, C;
	
		always@(Q1 or Q0) begin
			case({Q1, Q0})
				2'b00 : begin A='b0; B='b0; C='b0; end
				2'b01 : begin A='b0; B='b1; C='b0; end
				2'b10 : begin A='b1; B='b0; C='b0; end
				2'b11 : begin A='b1; B='b0; C='b1; end
			endcase
		end
endmodule	