module ledAlarm(

input clk,
input aux,
output reg LEDR

);

 // Utilizamos los 10 Leds del arreglo

reg [25:0] contador; /*Un contador de 25 bits (ante la posibilidad de 
						  modificar el código posteriormente.					
						  En nuestro caso bastarían 16 bits (50.000) */
						  
reg [25:0] cont2;
							  

always @(posedge clk)begin /*Nuestro contador aumenta en una unidad 
											cada vez que se sobrepasa un flanco de 
											subida de la señal de reloj*/

	
	
			if (aux==1)begin
			
				contador=contador+1;
				
			end
			else begin
			
				LEDR = 0;
				
			end


			if (contador==500)begin
											//98% Ciclo de trabajo
				LEDR =~LEDR;

			end	

			if (contador==50000)begin

				LEDR = ~ LEDR;
				contador=0;

			end

end

endmodule
