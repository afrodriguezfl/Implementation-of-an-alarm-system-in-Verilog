module servoPWM(clk,servo);

input clk;
output servo;
reg [19:0] counter1;
reg [19:0] counter2;
reg [19:0] counter3;
reg [30:0] counter4=0;
reg aux;
reg aux2;
reg servo_reg;
reg i;

//output files intelFPGA_lite/20.1
always @(posedge clk)begin

counter4<=counter4+1;
counter1<=counter1+1;


if(counter4==400_000_000)begin
	counter3<=120_000;
	counter4<=0;
end

if(counter4=='d350_000_000)
	counter3<='d108889;//counter3<='d108889

if(counter4=='d300_000_000)
	counter3<=95_000;//counter3<=97778

if(counter4=='d250_000_000)begin
	counter3<='d86667;
end

if(counter4=='d200_000_000)begin
	counter3<='d65556;
end

if(counter4=='d150_000_000)begin
	counter3<='d44445;
end

if(counter4=='d100_000_000)begin
	counter3<=20_000;
end

//Codificación de 1 movimiento


if (counter1==1_000_000)begin
	counter1<=0;
	aux<=1;
end
  
		if (aux==1)begin

			counter2<=counter2+1;
			servo_reg<=1;
				
				if(counter2==counter3)begin // 0 grados -> 20_000; 180 grados -> 120_000: counter3
				
					servo_reg<=0;
					counter2<=0;
					aux<=0;

				end

		end

	end


assign servo	= servo_reg;

endmodule
