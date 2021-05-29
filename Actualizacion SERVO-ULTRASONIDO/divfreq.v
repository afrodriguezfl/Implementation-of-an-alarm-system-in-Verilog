module divfreq(clk, clk1hz);
	input clk;
	output reg clk1hz;

	reg [27:0] count;

	always @ (posedge clk)begin

		if(count < 'd25_000)begin
			count = count + 1;
			end
		else begin
			count = 0;
			clk1hz = !clk1hz;
			end
	end
endmodule