`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
//////////////////////////////////////////////////////////////////////////////////
module top(
    input clk,
	 input [2:0] gState,
	 input [8:0] P1,
	 input [8:0] P2,
	 output [2:0] r,
	 output [2:0] g,
	 output [1:0] b,
	 output vSync,
	 output hSync
    );
	 
	 reg [3:0] cubo;
	 
	 wire [9:0] x;
	 wire [9:0] y;
	 
	 reg [2:0] iR = 0;
	 reg [2:0] iG = 0;
	 reg [1:0] iB = 0;
	 
	 VGA_ctrler vga
	 (
		.clk_50(clk),						// 50MHz Clock input
		.red_in(iR),							// Red color input, when generated outside
		.green_in(iG),						// Green color input, when generated outside
		.blue_in(iB),							// Blue color input, when generated outside
		.pixel_column(x),					// Column pixel counter
		.pixel_row(y), 					// Row pixel counter
		
		.red_out(r),				// Red color output, to VGA connector
		.green_out(g),			// Green color output, to VGA connector
		.blue_out(b),				// Blue color output, to VGA connector
		.horiz_sync_out(hSync),	// Horizontal Sync output, to VGA connector
		.vert_sync_out(vSync)	   // Vertical Sync output, to VGA connector
	 );
	 
	 
	 
	 //SE GRAFICARAN 3 COSAS: 1-el setup, 2-desarrollo del juego, 3-GameState
	 
	 always@(posedge clk) begin//1-SetUp
	 
	 //marco, rayas, cajas vacias (color negro)
		iR <= 'b000;
		iG <= 'b111;
		iB <= 'b11;
		
		if(x < 'd50) begin//marco exterior
			iR <= 'b111;
			iG <= 'b000;
			iB <= 'b00;
		end
		if(x > 'd590) begin
			iR <= 'b111;
			iG <= 'b000;
			iB <= 'b00;
		end
		if(y < 'd50) begin
			iR <= 'b111;
			iG <= 'b000;
			iB <= 'b00;
		end
		if(y > 'd430) begin
			iR <= 'b111;
			iG <= 'b000;
			iB <= 'b00;
		end
		
		//rayas verticales
		if(x>'d223 && x<'d233 && (y>'d50 && y<'d430))begin
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
			cubo <= 9;
		end
		if(x>'d403 && x<'d413 && (y>'d50 && y<'d430))begin
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
			cubo <= 9;
		end
		//rayas horizontales
		if(y>'d170 && y<'d180 && (x>'d50 && x<'d590))begin
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
			cubo <= 9;
		end
		if(y>'d300 && y<'d310 && (x>'d50 && x<'d590))begin
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
			cubo <= 9;
		end
		//cubos 0-8
		//cubo 0
		if(x>'d50 && x<'d223 && (y>'d50 && y<'d170))begin
			iR <= 'b000;
			iG <= 'b000;
			iB <= 'b00;
			cubo <= 0;
		end
		//cubo 1
		else if(x>'d233 && x<'d403 && (y>'d50 && y<'d170))begin
			iR <= 'b000;
			iG <= 'b000;
			iB <= 'b00;
			cubo <= 1;
		end
		//cubo 2
		else if(x>'d413 && x<'d586 && (y>'d50 && y<'d170))begin
			iR <= 'b000;
			iG <= 'b000;
			iB <= 'b00;
			cubo <= 2;
		end
		//cubo 3
		else if(x>'d50 && x<'d223 && (y>'d180 && y<'d300))begin
			iR <= 'b000;
			iG <= 'b000;
			iB <= 'b00;
			cubo <= 3;
		end
		//cubo 4
		else if(x>'d233 && x<'d403 && (y>'d180 && y<'d300))begin
			iR <= 'b000;
			iG <= 'b000;
			iB <= 'b00;
			cubo <= 4;
		end
		//cubo 5
		else if(x>'d413 && x<'d586 && (y>'d180 && y<'d300))begin
			iR <= 'b000;
			iG <= 'b000;
			iB <= 'b00;
			cubo <= 5;
		end
		//cubo 6
		else if(x>'d50 && x<'d223 && (y>'d310 && y<'d430))begin
			iR <= 'b000;
			iG <= 'b000;
			iB <= 'b00;
			cubo <= 6;
		end
		//cubo 7
		else if(x>'d233 && x<'d403 && (y>'d310 && y<'d430))begin
			iR <= 'b000;
			iG <= 'b000;
			iB <= 'b00;
			cubo <= 7;
		end
		//cubo 8
		else if(x>'d413 && x<'d586 && (y>'d310 && y<'d430))begin
			iR <= 'b000;
			iG <= 'b000;
			iB <= 'b00;
			cubo <= 8;
		end
		else
			cubo<= 9;
	 
	 //graficando 2-desarrollo del juego
		//player 1
		if(P1[cubo]==1)begin
			iR <= 'b000;
			iG <= 'b000;
			iB <= 'b11;
		end//player 2
		if(P2[cubo]==1)begin
			iR <= 'b000;
			iG <= 'b111;
			iB <= 'b00;
		end
	 
	 //graficando GameStatus
	 if( gState== 'd2 || gState =='d3)begin//wins
		if((x>'d5 &&x<'d20 && y>'d5 && y<'d40) || (x>='d20 && x<'d40 && y>'d5 && y<'d25))begin//palo de la p y bolita de la p
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
			end//W
		if((x>='d100 && x<'d140 && y>='d30 && y<='d40) || (x>='d100 && x<'d109 && y>='d5 && y<='d40) || (x>='d117 && x<'d125 && y>='d5 && y<='d40) ||(x>='d134 && x<'d142 && y>='d5 && y<='d40))begin //W
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
		end //I
		if(x>='d150 && x<'d165 && y>='d5 && y<='d40 )begin//I
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
		end//N
		if((x>='d170 && x<'d210 && y>='d5 && y<='d15) || (x>='d170 && x<'d180 && y>='d5 && y<='d40) || (x>='d200 && x<'d210 && y>='d5 && y<='d40))begin//N
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
		end//S
		if((x>='d220 && x<'d260 && y>='d5 && y<='d10) || (x>='d220 && x<'d260 && y>='d20 && y<='d25) || (x>='d220 && x<'d260 && y>='d35 && y<='d40) || (x>='d220 && x<'d225 && y>='d10 && y<='d20) || (x>='d255 && x<'d260 && y>='d25 && y<='d35))begin
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
		end
		if(gState == 'd2)begin//1
			if((x>='d45 && x<'d85 && y>='d30 && y<='d40) || (x>='d58 && x<'d73 && y>='d5 && y<='d40))begin 
				iR <= 'b111;
				iG <= 'b111;
				iB <= 'b11;
			end
		end
		if(gState == 'd3)begin//2
			if((x>='d45 && x<'d85 && y>='d5 && y<='d15) || (x>='d45 && x<'d85 && y>='d30 && y<='d40) || (x>='d45 && x<'d65 && y>='d20 && y<='d40) || (x>='d65 && x<'d85 && y>='d5 && y<='d20))begin 
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
			end
		end
	 end
	 
	 else if(gState=='d0 ||gState=='d1)begin
		if((x>'d5 &&x<'d20 && y>'d5 && y<'d40) || (x>='d20 && x<'d40 && y>'d5 && y<'d25))begin//palo de la p y bolita de la p
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
			end
		//M
		if((x>='d100 && x<'d140 && y>='d5 && y<='d20) || (x>='d100 && x<'d109 && y>='d5 && y<='d40) || (x>='d117 && x<'d125 && y>='d5 && y<='d40) ||(x>='d134 && x<'d142 && y>='d5 && y<='d40))begin //W
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
		end//O
		if((x>='d150 && x<'d190 && y>='d35 && y<='d40) ||(x>='d150 && x<'d190 && y>='d5 && y<='d15) ||(x>='d150 && x<'d160 && y>='d5 && y<='d40) ||(x>='d180 && x<'d190 && y>='d5 && y<='d40))begin
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
		end//V ->U
		if((x>='d200 && x<'d240 && y>='d35 && y<='d40)  ||(x>='d200 && x<'d210 && y>='d5 && y<='d40) ||(x>='d230 && x<'d240 && y>='d5 && y<='d40))begin
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
		end//E
		if((x>='d250 && x<'d290 && y>='d35 && y<='d40) ||(x>='d250 && x<'d290 && y>='d5 && y<='d15)||(x>='d250 && x<'d290 && y>='d20 && y<='d25) ||(x>='d250 && x<'d260 && y>='d5 && y<='d40) )begin
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
		end//S 220-260
		if((x>='d300 && x<'d340 && y>='d5 && y<='d10) || (x>='d300 && x<'d340 && y>='d20 && y<='d25) || (x>='d300 && x<'d340 && y>='d35 && y<='d40) || (x>='d300 && x<'d305 && y>='d10 && y<='d20) || (x>='d335 && x<'d340 && y>='d25 && y<='d35))begin
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
		end
		if(gState == 'd0)begin//1
			if((x>='d45 && x<'d85 && y>='d30 && y<='d40) || (x>='d58 && x<'d73 && y>='d5 && y<='d40))begin 
				iR <= 'b111;
				iG <= 'b111;
				iB <= 'b11;
			end
		end
		if(gState == 'd1)begin//2
			if((x>='d45 && x<'d85 && y>='d5 && y<='d15) || (x>='d45 && x<'d85 && y>='d30 && y<='d40) || (x>='d45 && x<'d65 && y>='d20 && y<='d40) || (x>='d65 && x<'d85 && y>='d5 && y<='d20))begin 
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
			end
		end
	end
	else if(gState == 'd4)begin
		if ((x>='d60 && x<'d100 && y>='d35 && y<='d40) ||(x>='d60 && x<'d100 && y>='d5 && y<='d15)||(x>='d60 && x<'d100 && y>='d20 && y<='d25) ||(x>='d60 && x<'d70 && y>='d5 && y<='d40) )begin
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
		end//R
		if((x>'d110 &&x<'d125 && y>'d5 && y<'d40) || (x>='d125 && x<'d150 && y>'d5 && y<'d25)|| (x>='d125 && x<'d138 && y>'d25 && y<'d32) ||(x>='d138 && x<'d150 && y>'d32 && y<'d40))begin//palo de la p y bolita de la p
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
		end//R
		if((x>'d160 &&x<'d175 && y>'d5 && y<'d40) || (x>='d175 && x<'d200 && y>'d5 && y<'d25) || (x>='d175 && x<'d188 && y>'d25 && y<'d32) ||(x>='d188 && x<'d200 && y>'d32 && y<'d40))begin//palo de la p y bolita de la p
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
		end//O
		if((x>='d210 && x<'d250 && y>='d35 && y<='d40) ||(x>='d210 && x<'d250 && y>='d5 && y<='d15) ||(x>='d210 && x<'d220 && y>='d5 && y<='d40) ||(x>='d240 && x<'d250 && y>='d5 && y<='d40))begin
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
		end
		if((x>'d260 &&x<'d275 && y>'d5 && y<'d40) || (x>='d275 && x<'d300 && y>'d5 && y<'d25) || (x>='d275 && x<'d288 && y>'d25 && y<'d32) ||(x>='d288 && x<'d300 && y>'d32 && y<'d40))begin//palo de la p y bolita de la p
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
		end
	end
	else if(gState == 'd5)begin
		if((x>='d125 &&x<='d140 && y>'d5 && y<'d40) || (x>='d100 && x<='d125 && y>'d15 && y<'d40))begin//d
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
		end//R
		if((x>'d150 &&x<'d165 && y>'d5 && y<'d40) || (x>='d165 && x<'d190 && y>'d5 && y<'d25)|| (x>='d165 && x<'d178 && y>'d25 && y<'d32) ||(x>='d188 && x<'d190 && y>'d32 && y<'d40))begin//palo de la p y bolita de la p
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
		end//A
		if((x>='d200 && x<'d240 && y>='d20 && y<='d30) ||(x>='d200 && x<'d240 && y>='d5 && y<='d15) ||(x>='d200 && x<'d210 && y>='d5 && y<='d40) ||(x>='d230 && x<'d240 && y>='d5 && y<='d40))begin
			iR <= 'b111;
			iG <= 'b111;
			iB <= 'b11;
		end//W
		if((x>='d250 && x<'d290 && y>='d30 && y<='d40) || (x>='d250 && x<'d259 && y>='d5 && y<='d40) || (x>='d267 && x<'d275 && y>='d5 && y<='d40) ||(x>='d284 && x<'d292 && y>='d5 && y<='d40))begin //W
			iR <= 'b111;											
			iG <= 'b111;
			iB <= 'b11;
		end
	end
end//end always

endmodule
