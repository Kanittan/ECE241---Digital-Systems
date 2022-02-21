

module RateDivider(Clock1, Reset1, q1);

	input Clock1;
	input Reset1;
	output reg q1;
	reg [7:0] count;

	always @(posedge Clock1, negedge Reset1)
		begin
			if (!Reset1)
				count <= 8'd249;
				
			else if (count == 0)
				count <= 8'd249;
				
			else
				count <= count - 1;
		end
		
		assign q1 = (count == 0) ? 1 : 0;
	
endmodule



module part3(ClockIn, Resetn, Start, Letter, DotDashOut);

	input ClockIn, Resetn, Start;
	input [2:0]Letter;
	output reg DotDashOut;
	
	reg [11:0]Load;
	wire Enable;
	
	RateDivider RD1(ClockIn, Resetn, Enable);

	always @(posedge Start, negedge Resetn)
		begin
				if (!Resetn)
					Load <= 0;
				else
					case (Letter)
						3'b000: Load = 12'b101110000000; //A
						3'b001: Load = 12'b111010101000; //B
						3'b010: Load = 12'b111010111010; //C
						3'b011: Load = 12'b111010100000; //D
						3'b100: Load = 12'b100000000000; //E
						3'b101: Load = 12'b101011101000; //F
						3'b110: Load = 12'b111011101000; //G
						3'b111: Load = 12'b101010100000; //H
						default: Load = 12'b000000000000;
					endcase
		end
		
	always @(posedge Enable, negedge Resetn)
		begin
			if (!Resetn)
				DotDashOut <= 0;
			else 
			begin
				DotDashOut <= Load[11];
				Load <= Load << 1;
				Load[0] <= Load[11];
			end
		end

endmodule