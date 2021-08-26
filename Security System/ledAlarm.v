module ledAlarm(

input clk,
input aux,
output reg [11:0] LEDR

);

 // Utilizamos los 10 Leds del arreglo

reg [25:0] contador; /*Un contador de 25 bits (ante la posibilidad de 
						  modificar el código posteriormente.					
						  En nuestro caso bastarían 16 bits (50.000) */
						  
							  

always @(posedge clk)begin /*Nuestro contador aumenta en una unidad 
											cada vez que se sobrepasa un flanco de 
											subida de la señal de reloj*/
			
		/*	if(aux==1)begin
			
				contador=contador+1;
			
			end
			else begin
			
				LEDR[11:0] <= 12'b111111111111;
			
			end
			
			
			
			
			if (contador <= 25_000_000)begin
			
				
				LEDR[11:0] <= 12'b111111111111;
				
				
			end
			else if (contador <= 50_000_000 && contador > 25_000_000)begin
			
				LEDR[11:0] <= 12'b000000000000;
			
			end
			
			if(contador==50_000_000)begin
				
				contador = 0;
				
			end 
			*/
			
			if(aux==1)begin

            contador=contador+1;

            if (contador <= 25_000_000)begin

                 LEDR[11:0] <= 12'b111111111111;

            end

            else if (contador < 50_000_000 && contador > 25_000_000)begin

                 LEDR[11:0] <= 12'b000000000000;

            end
            else if(contador==50_000_000)begin

             contador = 0;

            end 
        end
        else begin

             LEDR[11:0] <= 12'b111111111111;

        end


end

endmodule
