module Buzzer_alarm(clk, aux, speaker);
input clk;
input aux;
output speaker;


reg [27:0] tone;
always @(posedge clk)begin
	
	tone <= tone+1;

end

wire [6:0] fastsweep = (tone[22] ? tone[21:15] : ~tone[21:15]);
wire [6:0] slowsweep = (tone[25] ? tone[24:18] : ~tone[24:18]);
wire [14:0] clkdivider = {2'b01, (tone[27] ? slowsweep : fastsweep), 6'b000000};

reg [14:0] counter;
always @(posedge clk) if(counter==0) counter <= clkdivider; else counter <= counter-1;

reg speaker;
always @(posedge clk)begin

	if(counter==0)begin
		if(aux==0)begin
			speaker <= 1;
		end
		else begin
			speaker <= ~speaker;
		end
	end
	
 end
endmodule
