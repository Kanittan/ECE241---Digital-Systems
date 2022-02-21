 
`timescale 1ns / 1ps
// `default_nettype none

module main	(
	input wire CLOCK_50,            //On Board 50 MHz
	input wire [9:0] SW,            // On board Switches
	input wire [3:0] KEY,           // On board push buttons
	output wire [6:0] HEX0,         // HEX displays
	output wire [6:0] HEX1,         
	output wire [6:0] HEX2,         
	output wire [6:0] HEX3,         
	output wire [6:0] HEX4,         
	output wire [6:0] HEX5,         
	output wire [9:0] LEDR,         // LEDs
	output wire [7:0] x,            // VGA pixel coordinates
	output wire [6:0] y,
	output wire [2:0] colour,       // VGA pixel colour (0-7)
	output wire plot,               // Pixel drawn when this is pulsed
	output wire vga_resetn          // VGA resets to black when this is pulsed (NOT CURRENTLY AVAILABLE)
);  
	
	//Write code in here!
	hex_decoder u0(
       .c(SW[3:0]),
		  .display(HEX0[6:0])
		 );
	 //////////////////////////////////////////////////////////////////////////////
	 
	 // Stimulus
	 // assign SW[3:0] = 4'b0000;
	 assign SW[3:0] = 4'b0001;
	
endmodule





module hex_decoder(c, display);
	input [3:0]c;
	output reg[6:0]display;
	always @(*)
	case (c)
		4'h0: display = 7'b1000000;
		4'h1: display = 7'b1111001;
		4'h2: display = 7'b0100100; 
		4'h3: display = 7'b0110000;
		4'h4: display = 7'b0011001;
		4'h5: display = 7'b0010010;  
		4'h6: display = 7'b0000010;
		4'h7: display = 7'b1111000;
		4'h8: display = 7'b0000000;
		4'h9: display = 7'b0011000;
		4'hA: display = 7'b0001000; 
		4'hB: display = 7'b0000011;
		4'hC: display = 7'b1000110;
		4'hD: display = 7'b0100001;
		4'hE: display = 7'b1000110;
		4'hF: display = 7'b0001110;
	default: display = 7'h7f;
	endcase
endmodule
