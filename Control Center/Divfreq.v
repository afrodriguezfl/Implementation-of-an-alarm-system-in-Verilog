module Divfreq #(parameter ciclos)(i_clk, o_clk);
input i_clk;
output reg o_clk = 0;

reg [27:0] r_count = 0;

always @ (posedge i_clk)begin
	if(r_count < ciclos)begin
		r_count = r_count + 1;
		end
	else begin
		r_count = 0;
		o_clk = !o_clk;
		end
end
endmodule
