module mostrarnum(

		input clk,               //Reloj
		input [32:0] distance,
		output [0:6] sseg,       //7 Segmentos del display
		output reg [5:0] anodos, //Anodos(Selectores del display a usar): NUEVO 6 Ánodos
		output led, 
		output outservo

);
    
	reg led1, outservo1;
	reg [3:0] bcd;         //Posición de los switches(NUMERO INGRESADO)
	reg [3:0] contador;    //NUEVO: un contador de 1 a 6

	wire [3:0] dig1 = distance % 10;//Centímetros
	wire [3:0] dig2 = (distance / 10) % 10 ;//Decímetros
	wire [3:0] dig3 = (distance / 100) % 10;//Metros
	wire [3:0] dig4 = (distance / 1000) % 10;
	wire [3:0] dig5 = (distance / 10000) % 10;
	wire [3:0] dig6 = (distance / 100000) % 10;

	divfreq div(clk,clk1);

	sevensegs sev(bcd, sseg);

	always @(posedge clk1)begin

	contador <= contador + 1;

	case(contador)

		3'b000: begin bcd <= dig1[3:0]; anodos <= 6'b111110;end // 
		3'b001: begin bcd <= dig2[3:0]; anodos <= 6'b111101;end // 
		3'b010: begin bcd <= dig3[3:0]; anodos <= 6'b111011;end // Escribe dígito 1 en Hexadecimal
		3'b011: begin bcd <= dig4[3:0]; anodos <= 6'b110111;end // Escribe dígito 2 en Hexadecimal
	 //3'b100: begin bcd <= dig5[3:0]; anodos <= 6'b101111;end 
	 //3'b101: begin bcd <= dig6[3:0]; anodos <= 6'b011111;end

	endcase
	
	 
//	if(dig3==4'b0001)
//		led1<=0;
//	else
//		led1<=1;
		
				
//	if (dig2 >= 4'b0000 && dig1 >= 4'b1000) // Desde 8cm hasta Max cm, se abre
//		outservo1<=0;
		
//	else 

	if (dig2 == 4'b0000 && dig1 <= 4'b0111)// Desde 7cm a 0cm, se cierra
		outservo1<=1;		//intercambio 1<->0
	else 
		outservo1<=0;
   end 
	 
	assign led = led1;
	assign outservo = outservo1;
	 
endmodule
