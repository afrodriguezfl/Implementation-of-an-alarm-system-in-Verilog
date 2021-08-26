module Keypad_state_machine
 (
	input  i_Clk,       		// Main Clock
  
	input [3:0] i_Col,   	// Mapped to Columns
	output [3:0] o_Row,   	// Mapped to Rows

	// 7-Segment Displays, Segment1 is upper digit
	
	output [0:6] o_7Segments,
	output reg [7:0] o_Anodos,
	output wire [3:0] w_Decode_Out
);

//wire [3:0] w_Decode_Out;
wire [4:0] w_Line = 'b11111;
reg [4:0] r_BCD_NUM;
reg [2:0] r_Count;

Divfreq #(25000) Divfreq_Inst_1
	(.i_clk(i_Clk), 
	.o_clk(w_clk_1)
	);

Divfreq #(16000) Divfreq_Inst_2
	(.i_clk(i_Clk), 
	.o_clk(w_clk_2)
	);

Swept Swept_Inst
	(.i_clk(w_clk_2),
	.o_Row(o_Row)
	);

Decoder Decoder_Inst
	(.i_Row(o_Row),
	.i_Col(i_Col),  
	.DecodeOut(w_Decode_Out)
	);

BCD_To_7Segment SevenSeg_Inst
	(.i_BCD_Num(r_BCD_NUM),
	.o_HEX_Num(o_7Segments)
	);
	
always @(posedge w_clk_1)begin

r_Count <= r_Count + 1;

case(r_Count)
	3'b000: begin r_BCD_NUM <= w_Decode_Out[3:0];	o_Anodos <= 8'b11111110; end
	3'b001: begin r_BCD_NUM <= w_Line[4:0];			o_Anodos <= 8'b11111101; end
	3'b010: begin r_BCD_NUM <= w_Line[4:0];			o_Anodos <= 8'b11111011; end
	3'b011: begin r_BCD_NUM <= w_Line[4:0];			o_Anodos <= 8'b11110111; end
	3'b100: begin r_BCD_NUM <= w_Line[4:0];			o_Anodos <= 8'b11101111; end
	3'b101: begin r_BCD_NUM <= w_Line[4:0];			o_Anodos <= 8'b11011111; end
	3'b110: begin r_BCD_NUM <= w_Line[4:0];			o_Anodos <= 8'b10111111; end
	3'b111: begin r_BCD_NUM <= w_Line[4:0];			o_Anodos <= 8'b01111111; end
endcase

end 
endmodule