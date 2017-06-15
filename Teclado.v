`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: El ITESO nos roba
// Engineer: Vergillas Vargas & Cama de arena Camarena
//////////////////////////////////////////////////////////////////////////////////
module Teclado(
    input clk,
    input [3:0] col,
	 output reg isReady,
	 output reg [3:0] row,
    output reg [3:0] key
    );
	 
	 reg [1:0] scan;
	 reg [26:0] counter;
	 reg delay;
	 
	 always @(posedge clk)begin //localDelay
		if (counter == 2500000)
		begin
			counter <= 0;
			delay <= delay +1;
			end
		else
			counter<=counter + 1;
	  end
	 
	 always @(posedge delay) begin
	 
		scan = scan + 1;
		isReady = 1;
		
		case(scan)
			0:row <= 4'b1000;
			1:row <= 4'b0100;
			2:row <= 4'b0010;
			3:row <= 4'b0001;
			default: row <= 0;
		endcase
		
		if(col[3] || col[2] || col[1] || col[0])begin
			isReady = 0;
			
			if(row == 4'b1000)
				case(col)
					'b1000: key <= 'd1;
					'b0100: key <= 'd2;
					'b0010: key <= 'd3;
					'b0001: key <= 'd10;
				endcase
			if(row == 4'b0100)
				case(col)
					'b1000: key <= 'd4;
					'b0100: key <= 'd5;
					'b0010: key <= 'd6;
					'b0001: key <= 'd11;
				endcase
			if(row == 4'b0010)
				case(col)
					'b1000: key <= 'd7;
					'b0100: key <= 'd8;
					'b0010: key <= 'd9;
					'b0001: key <= 'd12;
				endcase
			if(row == 4'b0001)
				case(col)
					'b1000: key <= 'd15;
					'b0100: key <= 'd0;
					'b0010: key <= 'd14;
					'b0001: key <= 'd13;
				endcase
		end
	 end
	 
endmodule
