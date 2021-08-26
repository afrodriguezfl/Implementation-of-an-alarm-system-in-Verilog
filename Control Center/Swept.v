module Swept
(
    input i_clk,
    output reg [3:0] o_Row
);

reg [1:0] r_count=0;

always @(posedge i_clk)
begin
	case(r_count)
		2'b00: o_Row <= 4'b1000;
		2'b01: o_Row <= 4'b0100;
		2'b10: o_Row <= 4'b0010;
		2'b11: o_Row <= 4'b0001;
	endcase
	r_count <= r_count + 1;
end

endmodule
