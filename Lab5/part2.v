
module RateDivider(Clock1, Reset1, Speed1, q1);
	input Clock1;
	input Reset1;
	input [1:0] Speed1;
	
	output reg [10:0] q1;
	reg [10:0] tempq1;
	
	always @(*)
		begin
			if (Speed1 == 2'b00)
				tempq1 <= 11'd0;
				
			else if (Speed1 == 2'b01)
				tempq1 <= 11'd499;
				
			else if (Speed1 == 2'b10)
				tempq1 <= 11'd999;
				
			else if (Speed1 == 2'b11)
				tempq1 <= 11'd1999;
				
			else 
				tempq1 <= 11'd0;
		end
	
	always @(posedge Clock1)
		begin
			if (Reset1)
				q1 <= 0;
				
			else if(q1 == 0)
				q1 <= tempq1;
				
			else if (q1 != 0)
				q1 <= q1 - 1;
		end

endmodule


module part2(ClockIn, Reset, Speed, CounterValue);

	input ClockIn, Reset;
	input [1:0] Speed;
	output reg [3:0] CounterValue;
	
	wire [10:0] w1;
	wire Enable;
	
	RateDivider RD1(.Clock1(ClockIn), .Reset1(Reset), .Speed1(Speed), .q1(w1));
	
	assign Enable = (w1 == 0) ? 1 : 0;  //11'b00000000000
	
	always @(posedge ClockIn)
		begin
			if (Reset == 1) // 1'b1
				CounterValue <= 0;
				
			else if (CounterValue == 4'b1111)
				CounterValue <= 0;
				
			else if (Enable == 1) // 1'b1
				CounterValue <= CounterValue + 1;
		end

endmodule