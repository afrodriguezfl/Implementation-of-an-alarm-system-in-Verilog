module BCD_To_7Segment 
  (
  
   input [4:0]      i_BCD_Num,
   output reg [0:6] o_HEX_Num
	
   );

    always @(*) begin 
        case (i_BCD_Num)
				5'b00000: o_HEX_Num = 7'b0000001;
            5'b00001: o_HEX_Num = 7'b1001111;
            5'b00010: o_HEX_Num = 7'b0010010;
            5'b00011: o_HEX_Num = 7'b0000110;
            5'b00100: o_HEX_Num = 7'b1001100;
            5'b00101: o_HEX_Num = 7'b0100100;
            5'b00110: o_HEX_Num = 7'b0100000;
            5'b00111: o_HEX_Num = 7'b0001101;
            5'b01000: o_HEX_Num = 7'b0000000;
            5'b01001: o_HEX_Num = 7'b0000100;
            5'ha: o_HEX_Num = 7'b0001000;
            5'hb: o_HEX_Num = 7'b1100000;
            5'hc: o_HEX_Num = 7'b0110001;
            5'hd: o_HEX_Num = 7'b1000010;
            5'he: o_HEX_Num = 7'b0110000;
				5'hf: o_HEX_Num = 7'b0111000;
				5'b11111: o_HEX_Num = 7'b1111110;
        default: 
            o_HEX_Num = 7'b1111111;
        endcase
    end
endmodule 