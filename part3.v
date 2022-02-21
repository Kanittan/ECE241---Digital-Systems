
// 2 Bit Adder:
module FA (A, B, cin, s, cout);
	input A, B, cin;
	output s, cout;

	assign s = cin^A^B;
	assign cout = (A & B) | (cin & A) | (cin & B);
endmodule



// 4 Bit Adder:
module part2(a, b, c_in, s, c_out);
	input [3:0] a;
	input [3:0] b;  // a and b are 4 bit Input
	input c_in;

	output [3:0] s;  // Sum
	output [3:0] c_out;  // Carry Out

	FA u1(a[0], b[0], c_in, s[0], c_out[0]);
	FA u2(a[1], b[1], c_out[0], s[1], c_out[1]);
	FA u3(a[2], b[2], c_out[1], s[2], c_out[2]);
	FA u4(a[3], b[3], c_out[2], s[3], c_out[3]);
	
endmodule


module part3(A, B, Function, ALUout);
	input [2:0] Function;
	input [3:0] A;
	input [3:0] B;
	output reg [7:0] ALUout;

	wire [3:0] c; // c = carry
	wire [3:0] s; //s = sum
	wire [4:0] addition;
	
	part2 u5(A, B, 0, s, c);
	
	assign addition = A + B;
	
		
		always @(*) // declare always block
			begin
				case (Function [2:0]) // start case statement
					3'b000: ALUout = {3'b000, c[3], s};
					3'b001: ALUout = {3'b000, addition};
					3'b010: ALUout = {{4{B[3]}}, B};
					3'b011: ALUout = {(A | B) ? 8'b0000001 : 8'b0};
					3'b100: ALUout = {((&A) & (&B)) ? 8'b0000001 : 8'b0};
					3'b101: ALUout = {A, B};
					default: ALUout = 8'b00000000;
				endcase
			end
endmodule

