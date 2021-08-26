module Decoder(
    //input [3:0] i_clk,
    input [3:0] i_Row,
    input [3:0] i_Col,
    output reg [3:0] DecodeOut
    );
always@(*)
begin

	if(i_Col == 4'b1000)begin 
		case(i_Row)
			4'b1000: DecodeOut <= 4'b0001;
			4'b0100: DecodeOut <= 4'b0100;
			4'b0010: DecodeOut <= 4'b0111;
			4'b0001: DecodeOut <= 4'b1110;
		default: DecodeOut <= 4'b0000;
		endcase
	end

	if(i_Col == 4'b0100)begin 
		case(i_Row)
			4'b1000: DecodeOut <= 4'b0010;
			4'b0100: DecodeOut <= 4'b0101;
			4'b0010: DecodeOut <= 4'b1000;
			4'b0001: DecodeOut <= 4'b0000;
		default: DecodeOut <= 4'b0000;
		endcase
	end
	
	if(i_Col == 4'b0010)begin 
		case(i_Row)
			4'b1000: DecodeOut <= 4'b0011;
			4'b0100: DecodeOut <= 4'b0110;
			4'b0010: DecodeOut <= 4'b1001;
			4'b0001: DecodeOut <= 4'b1111;
		default: DecodeOut <= 4'b0000;
		endcase
	end
	
	if(i_Col == 4'b0001)begin 
		case(i_Row)
			4'b1000: DecodeOut <= 4'b1010;
			4'b0100: DecodeOut <= 4'b1011;
			4'b0010: DecodeOut <= 4'b1100;
			4'b0001: DecodeOut <= 4'b1101;
		default: DecodeOut <= 4'b0000;
		endcase
	end

end 

endmodule
