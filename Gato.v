`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
//////////////////////////////////////////////////////////////////////////////////
	module Gato(
	 /*Kernel I/O*/
    input clk,
	 input reset,
	 /*Keyboard I/O*/
	 output [3:0] row,
	 input [3:0] col,
	 /*Display I/O*/
	 output [2:0]r,
	 output [2:0]g,
	 output [1:0]b,
	 output vSync,
	 output hSync,
	 output listening,
	 output p1
    );
	 
	 /*|||||||||||||||Wires & Regs|||||||||||||||*/
	 /*Kernel regs & wires*/
	 reg [2:0]previousGameState=0;
	 reg [2:0]gameState=0;
	 reg [8:0]player1=0;
	 reg [8:0]player2=0;
	 reg sleepEnable=0;
	 
	 wire [2:0] wDisplayState;
	 wire [8:0] wDisplayP1;
	 wire [8:0] wDisplayP2;
	 
	 assign wDisplayState=gameState;
	 assign wDisplayP1 = player1;
	 assign wDisplayP2 = player2;
	 
	 assign p1 = wDisplayP1[0];	 
	 /*KeyBoard wires*/
	 wire wKbIsReady;
	 wire [3:0]wKbKey;
	 
	 /*|||||||||||Module Instantiation||||||||||||*/
	 Teclado keyboard
	 (
		.clk(clk),
		.col(col), //FROM volt
		.isReady(wKbIsReady),
		.row(row), //to voltage
		.key(wKbKey)
	 );
	 assign listening = ~wKbIsReady;
	 
	 top display
	 (
		.clk(clk),
		.gState(wDisplayState),
		.P1(wDisplayP1),
		.P2(wDisplayP2),
		.r(r),
		.g(g),
		.b(b),
		.vSync(vSync),
		.hSync(hSync)
	 );
	 
	 /*LOCAL DELAY BLOCK*/
	 reg [26:0] mainDelayCounter = 0;
	 reg mainDelay;
	 always @(posedge clk)begin //localDelay
		if (mainDelayCounter == 2500000)
		begin
			mainDelayCounter <= 0;
			mainDelay <= mainDelay +1;
			end
		else
			mainDelayCounter<=mainDelayCounter + 1;
	  end
	  /*LOCAL DELAY BLOCK*/
	  
	  /*Display ERROR DELAY BLOCK*/
	 reg [50:0] displayCounter = 0;
	 reg displayDelay;
	 always @(posedge clk)begin //localDelay
		if(sleepEnable)begin
			if (displayCounter == 45000000)
			begin
				displayCounter <= 0;
				displayDelay <= displayDelay +1;
				end
			else
				displayCounter<=displayCounter + 1;
			end
		else
			displayDelay <= 0;
	  end
	  /*Display ERROR DELAY BLOCK*/
	 
	 always@(posedge mainDelay) begin
		if(reset) begin
			gameState <= 0;
			previousGameState <= 0;
			player1 <= 0;
			player2 <= 0;
		end
		case(gameState)
			0:begin
				//p1 move
				if((player1[0]|player2[0])&&(player1[1]|player2[1])&&(player1[2]|player2[2])&&(player1[3]|player2[3])&&(player1[4]|player2[4])&&(player1[5]|player2[5])&&(player1[6]|player2[6])&&(player1[7]|player2[7]&&(player1[8]|player2[8])))
					gameState<=5;
				else if(~wKbIsReady) begin
				   // key recieved - check if move is valid
					gameState<=1; //assume move is correct, second player turn
					previousGameState<=0;
					case(wKbKey)
						1:begin
							if(player1[0] != 1 && player2[0] != 1) 
							begin
								player1[0] <= 1;
								if((player1[1]&&player1[2]) | (player1[4]&&player1[8]) | (player1[3]&&player1[6]))
									gameState<=2;
							end
							else
								gameState<=4;
						end
						2:begin
							if(player1[1] != 1 && player2[1] != 1) 
							begin
								player1[1] <= 1;
								if((player1[0]&&player1[2]) | (player1[4]&&player1[7]))
									gameState<=2;
							end
							else
								gameState<=4;
						end
						3:begin
							if(player1[2] != 1 && player2[2] != 1) 
							begin
								player1[2] <= 1;
								if((player1[0]&&player1[1]) | (player1[6]&&player1[4]) | (player1[5]&&player1[8]))
									gameState<=2;
							end
							else
								gameState<=4;
						end
						4:begin
							if(player1[3] != 1 && player2[3] != 1) 
							begin
								player1[3] <= 1;
								if((player1[0]&&player1[6]) | (player1[4]&&player1[5]))
									gameState<=2;
							end
							else
								gameState<=4;
						end
						5:begin
							if(player1[4] != 1 && player2[4] != 1) 
							begin
								player1[4] <= 1;
								if((player1[0]&&player1[8]) | (player1[1]&&player1[7]) | (player1[6]&&player1[2]) | (player1[3]&&player1[5]))
									gameState<=2;
							end
							else
								gameState<=4;
						end
						6:begin
							if(player1[5] != 1 && player2[5] != 1) 
							begin
								player1[5] <= 1;
								if((player1[4]&&player1[3]) | (player1[2]&&player1[8]))
									gameState<=2;
							end
							else
								gameState<=4;
						end
						7:begin
							if(player1[6] != 1 && player2[6] != 1) 
							begin
								player1[6] <= 1;
								if((player1[0]&&player1[3]) | (player1[2]&&player1[4]) | (player1[7]&&player1[8]))
									gameState<=2;
							end
							else
								gameState<=4;
						end
						8:begin
							if(player1[7] != 1 && player2[7] != 1) 
							begin
								player1[7] <= 1;
								if((player1[4]&&player1[1]) | (player1[6]&&player1[8]))
									gameState<=2;
							end
							else
								gameState<=4;
						end
						9:begin
							if(player1[8] != 1 && player2[8] != 1) 
							begin
								player1[8] <= 1;
								if((player1[0]&&player1[4]) | (player1[2]&&player1[5]) | (player1[7]&&player1[6]))
									gameState<=2;
							end
							else
								gameState<=4;
						end
						default: gameState<=4;
					endcase
				end
			end
			1:begin
				//p2 move
				if((player1[0]|player2[0])&&(player1[1]|player2[1])&&(player1[2]|player2[2])&&(player1[3]|player2[3])&&(player1[4]|player2[4])&&(player1[5]|player2[5])&&(player1[6]|player2[6])&&(player1[7]|player2[7]&&(player1[8]|player2[8])))
					gameState<=5;
				else if(~wKbIsReady) begin
				   // key recieved - check if move is valid
					gameState<=0; //assume move is correct, second player turn
					previousGameState<=1;
					case(wKbKey)
						1:begin
							if(player1[0] != 1 && player2[0] != 1) 
							begin
								player2[0] <= 1;
								if((player2[1]&&player2[2]) | (player2[4]&&player2[8]) | (player2[3]&&player2[6]))
									gameState<=3;
							end
							else
								gameState<=4;
						end
						2:begin
							if(player1[1] != 1 && player2[1] != 1) 
							begin
								player2[1] <= 1;
								if((player2[0]&&player2[2]) | (player2[4]&&player2[7]))
									gameState<=3;
							end
							else
								gameState<=4;
						end
						3:begin
							if(player1[2] != 1 && player2[2] != 1) 
							begin
								player2[2] <= 1;
								if((player2[0]&&player2[1]) | (player2[6]&&player2[4]) | (player2[5]&&player2[8]))
									gameState<=3;
							end
							else
								gameState<=4;
						end
						4:begin
							if(player1[3] != 1 && player2[3] != 1) 
							begin
								player2[3] <= 1;
								if((player2[0]&&player2[6]) | (player2[4]&&player2[5]))
									gameState<=3;
							end
							else
								gameState<=4;
						end
						5:begin
							if(player1[4] != 1 && player2[4] != 1) 
							begin
								player2[4] <= 1;
								if((player2[0]&&player2[8]) | (player2[1]&&player2[7]) | (player2[6]&&player2[2]) | (player2[3]&&player2[5]))
									gameState<=3;
							end
							else
								gameState<=4;
						end
						6:begin
							if(player1[5] != 1 && player2[5] != 1) 
							begin
								player2[5] <= 1;
								if((player2[4]&&player2[3]) | (player2[2]&&player2[8]))
									gameState<=3;
							end
							else
								gameState<=4;
						end
						7:begin
							if(player1[6] != 1 && player2[6] != 1) 
							begin
								player2[6] <= 1;
								if((player2[0]&&player2[3]) | (player2[2]&&player2[4]) | (player2[7]&&player2[8]))
									gameState<=3;
							end
							else
								gameState<=4;
						end
						8:begin
							if(player1[7] != 1 && player2[7] != 1) 
							begin
								player2[7] <= 1;
								if((player2[4]&&player2[1]) | (player2[6]&&player2[8]))
									gameState<=3;
							end
							else
								gameState<=4;
						end
						9:begin
							if(player1[8] != 1 && player2[8] != 1) 
							begin
								player2[8] <= 1;
								if((player2[0]&&player2[4]) | (player2[2]&&player2[5]) | (player2[7]&&player2[6]))
									gameState<=3;
							end
							else
								gameState<=4;
						end
						default: gameState<=4;
					endcase
				end
			end
			2:begin
				//p1 wins
				player1 <= 0;
				player2 <= 0;
				sleepEnable <= 1;
				if(displayDelay == 1) begin
					sleepEnable <= 0;
					gameState <= 0; 
				end
			end
			3:begin
				//p2 wins
				player1 <= 0;
				player2 <= 0;
				sleepEnable <= 1;
				if(displayDelay == 1) begin
					sleepEnable <= 0;
					gameState <= 0; 
				end
			end
			4:begin
				//Error -> Bad move
				sleepEnable <= 1;
				if(displayDelay == 1) begin
					//end of state of error
					sleepEnable <= 0;
					gameState <= previousGameState; 
				end
			end
			5:begin
				//game is a draw
				player1 <= 0;
				player2 <= 0;
				sleepEnable <= 1;
				if(displayDelay == 1) begin
					sleepEnable <= 0;
					gameState <= 0; 
				end
			end
		endcase
	 end
	 
	 

endmodule
