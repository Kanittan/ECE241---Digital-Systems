
// Lab4 Part 3:

// 2-to-1 Multiplexer
module mux2to1(x, y, s, m);
	
	input x;
	input y;
	input s;
	output m;
	
	assign m = (x & ~s)|(y & s);
endmodule


// Flip Flop with Active High Synchronous Reset
module flipflop (clock, reset, d, q);

	input clock;
	input reset;
	input d;
	output reg q;
	
	always @(posedge clock)
	begin 
		if (reset == 1'b1)
			q <= 0;
		else
			q <= d;
	end	
endmodule



module circuit2 (left, right, clock, FillLeft, D, Loadn, Reset, Q);

	input left;
	input right;
	input clock;
	input FillLeft;
	input D;
	input Loadn;
	input Reset;
	
	output Q;

	wire w1, w2;

	mux2to1 u1(.x(right), .y(left), .s(FillLeft), .m(w1));
	mux2to1 u2(.x(D), .y(w1), .s(Loadn), .m(w2));

	flipflop f1(.d(w2), .reset(Reset), .clock(clock), .q(Q));

endmodule 



module part3(clock, reset, ParallelLoadn, RotateRight, ASRight, Data_IN, Q);
	
	input clock;
	input reset;
	input ParallelLoadn;
	input RotateRight;
	input ASRight;
	input [7:0] Data_IN;
	output [7:0] Q;
	
	wire w3;
		
	mux2to1 u3(Q[0], Q[7], ASRight, w3);
	
	circuit2 q0(.left(Q[1]), .right(Q[7]), .clock(clock), .FillLeft(RotateRight), .D(Data_IN[0]), .Loadn(ParallelLoadn), .Reset(reset), .Q(Q[0]));
	circuit2 q1(.left(Q[2]), .right(Q[0]), .clock(clock), .FillLeft(RotateRight), .D(Data_IN[1]), .Loadn(ParallelLoadn), .Reset(reset), .Q(Q[1]));
	circuit2 q2(.left(Q[3]), .right(Q[1]), .clock(clock), .FillLeft(RotateRight), .D(Data_IN[2]), .Loadn(ParallelLoadn), .Reset(reset), .Q(Q[2]));
	circuit2 q3(.left(Q[4]), .right(Q[2]), .clock(clock), .FillLeft(RotateRight), .D(Data_IN[3]), .Loadn(ParallelLoadn), .Reset(reset), .Q(Q[3]));
	circuit2 q4(.left(Q[5]), .right(Q[3]), .clock(clock), .FillLeft(RotateRight), .D(Data_IN[4]), .Loadn(ParallelLoadn), .Reset(reset), .Q(Q[4]));
	circuit2 q5(.left(Q[6]), .right(Q[4]), .clock(clock), .FillLeft(RotateRight), .D(Data_IN[5]), .Loadn(ParallelLoadn), .Reset(reset), .Q(Q[5]));
	circuit2 q6(.left(Q[7]), .right(Q[5]), .clock(clock), .FillLeft(RotateRight), .D(Data_IN[6]), .Loadn(ParallelLoadn), .Reset(reset), .Q(Q[6]));
	circuit2 q7(.left(w3), .right(Q[6]), .clock(clock), .FillLeft(RotateRight), .D(Data_IN[7]), .Loadn(ParallelLoadn), .Reset(reset), .Q(Q[7]));

endmodule