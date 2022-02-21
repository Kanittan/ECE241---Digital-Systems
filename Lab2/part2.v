// 74LS04/05 (six inverters)
module v7404 (pin1, pin3, pin5, pin9, pin11, pin13, pin2, pin4, pin6, pin8, pin10, pin12);
input pin1, pin3, pin5, pin9, pin11, pin13;
output  pin2, pin4, pin6, pin8, pin10, pin12;

assign pin2 = ~pin1;
assign pin4 = ~pin3;
assign pin6 = ~pin5;
assign pin8 = ~pin9;
assign pin10 = ~pin11;
assign pin12 = ~pin13;

endmodule

module v7408 (pin1, pin2, pin4, pin5, pin9, pin10, pin12, pin13, pin3, pin6, pin8, pin11);
input pin1, pin2, pin4, pin5, pin9, pin10, pin12, pin13;
output pin3, pin6, pin8, pin11;

assign pin3 = pin1 & pin2;
assign pin6 =  pin4 & pin5;
assign pin8 = pin9 & pin10;
assign pin11 = pin12 & pin13;

endmodule

// 74LS32 (four 2-input OR gates)
module v7432 (pin1, pin2, pin4, pin5, pin9, pin10, pin12, pin13, pin3, pin6, pin8, pin11);
input pin1, pin2, pin4, pin5, pin9, pin10, pin12, pin13;
output pin3, pin6, pin8, pin11;

assign pin3 = (pin1)|(pin2);
assign pin6 =  (pin4)|(pin5);
assign pin8 = (pin9)|(pin10);
assign pin11 = (pin12)|(pin13);

endmodule


module mux2to1 (x,y,s,m);
//module mux2to1(SW, LEDR);

input x, y, s;
output m;

// Remove Below after Simulation Test
//input [9:0] SW;
//output [9:0] LEDR;

wire AND1_in, AND2_in, OR1_in, OR2_in;

// NOT Gate#1:
//v7404 NOT_GATE1(.pin1(s), .pin2(AND1_in));

// NOT Gate #2:
v7404 NOT_GATE2(.pin3(s), .pin4(AND2_in));

// AND Gate#1
v7408 AND_GATE1(.pin1(x), .pin2(AND2_in), .pin3(OR1_in));

// AND GATE#2
v7408 AND_GATE2(.pin1(y), .pin2(s), .pin3(OR2_in));

// OR Gate
v7432 OR_GATE1(.pin1(OR1_in), .pin2(OR2_in), .pin3(m));

endmodule