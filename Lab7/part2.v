//
// This is the template for Part 2 of Lab 7.
//
// Paul Chow
// November 2021
//

module part2(iResetn, iPlotBox, iBlack, iColour, iLoadX, iXY_Coord, iClock, oX, oY, oColour, oPlot);
   parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;
   
   input wire iResetn, iPlotBox, iBlack, iLoadX;
   input wire [2:0] iColour;
   input wire [6:0] iXY_Coord;
   input wire 	     iClock;
	
   output wire [7:0] oX;         // VGA pixel coordinates
   output wire [6:0] oY;
   
   output wire [2:0] oColour;     // VGA pixel colour (0-7)
   output wire 	     oPlot;       // Pixel draw enable                  
	
	wire [3:0] count;
	wire dataOutControl;
	wire loadIn_x;
	wire loadIn_y;
	
	
	control u1(.Clock(iClock), .Reset(iResetn), .Load(iLoadX), .plotBox(iPlotBox), .load_x(loadIn_x), .load_y(loadIn_y), .dataOutControl(dataOutControl), .draw(oPlot), .Counter(count), .black_Screen(iBlack));
	
   datapath u2(.Clock(iClock), .Reset(iResetn), .select_ALU(iXY_Coord), .Colour(iColour), .load_x(loadIn_x), .load_y(loadIn_y), .dataInPath(dataOutControl), .pos_x(oX), 
					.pos_y(oY), .outputColour(oColour), .Counter(count));
	

endmodule


module control(Clock, Reset, Load, plotBox, black_Screen, Counter,load_x, load_y, dataOutControl, draw);
	input Clock;
	input Reset;
	input Load;
	input plotBox;
	input black_Screen;
	input [3:0] Counter;
	
	output reg load_x;
	output reg load_y;
	output reg dataOutControl;
	output reg draw;
	
	reg [2:0] statePresent; //current_state plot
	reg[2:0] stateNew; // next_state

	localparam 	S_LOAD_X 				= 3'b000, // 3'd0, (Original)
					S_LOAD_X_WAIT 			= 3'b001, // 3'd1, (Original) 
					S_LOAD_Y 				= 3'b010, // 3'd2, (Original)
					S_LOAD_Y_WAIT 			= 3'b011, // 3'd3, (Original)
					S_CYCLE_PLOT 			= 3'b100, // 3'd4, (Original)
					S_CYCLE_PLOT_WAIT 	= 3'b101; // 3'd5; (Original)
					
	 // Next state logic aka our state table					
	 always@(*)
		 begin: state_table 
				case (statePresent)
								S_LOAD_X: 		stateNew = Load ? S_LOAD_X_WAIT : S_LOAD_X; 
								S_LOAD_X_WAIT: stateNew = Load ? S_LOAD_X_WAIT : S_LOAD_Y;
								S_LOAD_Y: 		stateNew = plotBox ? S_LOAD_Y_WAIT : S_LOAD_Y; 
								S_LOAD_Y_WAIT: stateNew = plotBox ? S_LOAD_Y_WAIT : S_CYCLE_PLOT;
								
								S_CYCLE_PLOT: 
									begin
										if(Counter == 4'b1111) // Original: 4'd15
											stateNew = S_CYCLE_PLOT_WAIT;
										else
											stateNew = S_CYCLE_PLOT;
									end
								S_CYCLE_PLOT_WAIT: stateNew = S_LOAD_X;
					default: stateNew = S_LOAD_X;
			  endcase
		 end // state_table
	
	always @(*)
		begin: enable_signals
		// By default make all our signals 0
			load_x = 1'b0;
			load_y = 1'b0;
			dataOutControl = 1'b0;
		  
		  if(statePresent == S_LOAD_X)
				begin
					load_x = 1'b1; 
					draw = 1'b0;
				end
			
			else if(statePresent == S_LOAD_Y)
				begin
					load_y = 1'b1;
					draw = 1'b0;
				end
				
			else if(statePresent == S_CYCLE_PLOT)
				begin
					dataOutControl = 1'b1; 
					draw = 1'b1;
				end
		  
//        case (current_state)
//            S_LOAD_X: begin
//                ld_x = 1'b1; 
//					 plot = 1'b0;
//					 end
//            S_LOAD_Y: begin
//                ld_y = 1'b1;
//					 plot = 1'b0;
//					 end
//            S_CYCLE_PLOT: begin
//                dataOut = 1'b1; 
//					 plot = 1'b1;
//					 end
//				 // default: don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
//			endcase
		end // enable_signals

		always@(posedge Clock) 
			begin: reset //NO CHANGE: Use reset
				if(black_Screen == 1) // Original: if(black_Screen) 
					begin

					end
			end
	
	// current_state registers
	always@(posedge Clock)
		begin: state_FFs
			if(Reset == 0) //Original: if(!Reset)
				statePresent <= S_LOAD_X;
			else
				statePresent <= stateNew;
		end // state_FFS

endmodule


module datapath(Clock, Reset, load_x, load_y, dataInPath, Colour, select_ALU,
					Counter, pos_x, pos_y, outputColour);
					
	input Clock;
	input Reset;
	input load_x; // ld_x
	input load_y; // ld_y
	input dataInPath; // dataIn 
	input [2:0] Colour; // colour
	input [6:0] select_ALU; // alu_select_xy_coord
					
	output reg [3:0] Counter; // counter
	output reg [7:0] pos_x; // x_coord
	output reg [6:0] pos_y; // y_coord
	output reg [2:0] outputColour; // colour_output
	
	reg [7:0] x; // x_reg
	reg [6:0] y; // y_reg
	reg [2:0] colour_temp; // colour_reg
	
	reg [3:0] count;
	
	always @(posedge Clock)
		begin
		  if(Reset == 0)
				count <= 4'd0; // Original: 4'b0000
		  else if(count == 4'd15) // Original: 4'b1111
				count <= 4'd0; // Original: 4'b0000
		  else if(dataInPath == 1) // Original: else if(dataInPath)
				count <= count + 1;
		end
		
		assign Counter = count;

	always@(posedge Clock)
		begin
			if(Reset == 0)
				begin
					pos_x <= 8'd0; // Original: 8'b00000000
					pos_y <= 7'd0;  // Original: 7'b0000000
					outputColour <= 3'd0; // Original: 3'b000
				end
			else if (load_x == 1)  // Original: else if(load_x)
				begin
					x <= {0, select_ALU};
				end
			else if (load_y == 1)  // Original: else if(load_y)
				begin
					y <= select_ALU;
					colour_temp <= Colour;
				end
			else if (dataInPath)
				begin
					pos_x <= x + Counter[1:0];
					pos_y <= y + Counter[3:2];
					outputColour <= colour_temp;
				end
		end
		
endmodule