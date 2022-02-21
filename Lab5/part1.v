
// Verilog Code: T Flip-Flop //

module Tff(clock, enable, clear_n, q);
input clock, enable, clear_n;
output reg q;

	always@(posedge clock, negedge clear_n)
		begin
			if(clear_n == 0)
				q <= 0;
				
			else if(enable == 1)
				q <= q+1;
		end
endmodule
			



module part1(Clock, Enable, Clear_b, CounterValue);
	
input Clock, Enable, Clear_b;
output [7:0]CounterValue;
//output reg [7:0]CounterValue;
//
//	always@(posedge Clock, negedge Clear_b)
//	begin
//		if(Clear_b == 0)
//			CounterValue <= 0;
//		
//		else if(Enable == 1)
//			CounterValue <= CounterValue+1;
//			
//	end

wire [6:0]w;
assign w[0] = Enable & CounterValue[0];
assign w[1] = w[0] & CounterValue[1];
assign w[2] = w[1] & CounterValue[2];
assign w[3] = w[2] & CounterValue[3];
assign w[4] = w[3] & CounterValue[4];
assign w[5] = w[4] & CounterValue[5];
assign w[6] = w[5] & CounterValue[6];


Tff tff1(.clock(Clock), .enable(Enable), .clear_n(Clear_b), .q(CounterValue[0]));
Tff tff2(.clock(Clock), .enable(w[0]), .clear_n(Clear_b), .q(CounterValue[1]));
Tff tff3(.clock(Clock), .enable(w[1]), .clear_n(Clear_b), .q(CounterValue[2]));
Tff tff4(.clock(Clock), .enable(w[2]), .clear_n(Clear_b), .q(CounterValue[3]));
Tff tff5(.clock(Clock), .enable(w[3]), .clear_n(Clear_b), .q(CounterValue[4]));
Tff tff6(.clock(Clock), .enable(w[4]), .clear_n(Clear_b), .q(CounterValue[5]));
Tff tff7(.clock(Clock), .enable(w[5]), .clear_n(Clear_b), .q(CounterValue[6]));
Tff tff8(.clock(Clock), .enable(w[6]), .clear_n(Clear_b), .q(CounterValue[7]));

endmodule