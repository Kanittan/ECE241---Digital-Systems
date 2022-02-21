
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