// ECE241 Lab4 Part 2:

// FROM PART 3 Of Lab3:
// 2 Bit Adder: Full Adder
module FA (A, B, cin, s, cout);
	input A, B, cin;
	output s, cout;

	assign s = cin^A^B;
	assign cout = (A & B) | (cin & A) | (cin & B);
endmodule



// 4 Bit Adder: Ripple Carry Adder
module RCA(a, b, c_in, s, c_out);
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



// Lab4 Part 2:

module part2(Clock, Reset_b, Data, Function, ALUout);

	input Reset_b;
	input Clock;
	input [3:0] Data;
	input [2:0] Function;
	
	output reg [7:0] ALUout;
	reg [7:0] ALU_new;
	
	wire [3:0] B;
	wire [3:0] s; //sum
	wire [3:0] c; // carry
	wire [4:0] addition;
	wire [4:0] multiplication;
	
	assign B = ALUout[3:0];
	assign addition = Data + B;
	assign multiplication = Data * B;
	
	RCA u5(Data, B, 0, s, c);
	
	always @(*)
		begin
			case(Function[2:0])
				3'b000: ALU_new = {3'b000, c[3], s};
				3'b001: ALU_new = {3'b000, addition};
				3'b010: ALU_new = {{4{B[3]}}, B};
				3'b011: ALU_new = {(Data | B) ? 8'b00000001 : 8'b0};
				3'b100: ALU_new = {((&Data) & (&B)) ? 8'b00000001 : 8'b0};
				3'b101: ALU_new = {4'b0000,B} << Data;	
				3'b110: ALU_new = {3'b000, multiplication};
				3'b111: ALU_new = ALUout;
				default: ALU_new = 8'b00000000;
			endcase
		end

	always @(posedge Clock)
		begin
			if(Reset_b == 1'b0)
			
				ALUout <= 8'b00000000;
			else
				ALUout <= ALU_new;
		end
		
endmodule