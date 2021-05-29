module servoPWM( clk, servo , activacion);

input clk;
input activacion;
output servo;
reg [19:0] counter1;
reg [19:0] counter2;
reg [19:0] counter3=20_000;
reg [19:0] counter4;
reg aux;
reg aux2;
reg servo_reg;
reg i;


always @(posedge clk)begin

counter1<=counter1+1;
counter4<=counter4+1;

//Codificación de 2 movimientos (SUBIDA Y BAJADA)------------------------------------------------

/*Formula: 

	tiempo(s) = (100_000/Numero de puntos)*2ms
	
	2ms -> (1/(50_000_000))*100_000
	
	Ejemplo: 160 puntos -> 2s ACTUAL
				80 puntos -> 4s
				65 puntos --> 3s

*/

//BAJADA 

if(activacion==0)begin // De 180° a 0°

	if(counter4==100_000)begin
	
		if(counter3>20_000)begin
		
			counter3<=counter3-160; 
			counter4<=0;
			
		end
		
	end

end

//SUBIDA
if(activacion==1)begin // De 0° a 180°
	
	if(counter4==100_000)begin // cada 0.02 segundos entra
	
		if(counter3<120_000)begin
		
			counter3<=counter3+160; //4s -> 80 puntos de subida
			counter4<=0;
		
		end
	
	end
	
end



//Codificación de 1 movimiento - Divisor de frecuencias principal--------------------------------

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

//module servoPWM(clk,servo,insonic);
//
//input clk;
//input [25:0] insonic;//Entrada del valor actual de servo (20_000-120_000)
//output servo;
//reg [19:0] counter1;
//reg [19:0] counter2;
///*reg [19:0] counter3;
//reg [30:0] counter4=0;*/
//reg aux;
//reg aux2;
//reg servo_reg;
//reg i;
//
////output files intelFPGA_lite/20.1
//always @(posedge clk)begin
//
////counter4<=counter4+1;
//counter1<=counter1+1;
//
//
///*if(counter4==400_000_000)begin
//	counter3<=120_000;
//	counter4<=0;
//end
//
//if(counter4=='d350_000_000)
//	counter3<='d108889;//counter3<='d108889
//
//if(counter4=='d300_000_000)
//	counter3<=95_000;//counter3<=97778
//
//
//
//if(counter4=='d250_000_000)begin
//	counter3<='d86667;
//end
//
//
//if(counter4=='d200_000_000)begin
//	counter3<='d65556;
//end
//
//
//if(counter4=='d150_000_000)begin
//	counter3<='d44445;
//end
//
//if(counter4=='d100_000_000)begin
//	counter3<=20_000;
//end*/
//
////Codificación de 1 movimiento
//
//
//if (counter1==1_000_000)begin
//	counter1<=0;
//	aux<=1;
//end
//  
//		if (aux==1)begin
//
//				counter2<=counter2+1;
//				servo_reg<=1;
//					
//					if(counter2==insonic)begin // 0 grados -> 20_000; 180 grados -> 120_000: inSonic
//					
//						servo_reg<=0;
//						counter2<=0;
//						aux<=0;
//
//					end
//
//		end
//
//	end
//
//
//assign servo	= servo_reg;
//
//endmodule
