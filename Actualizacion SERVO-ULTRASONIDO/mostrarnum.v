module mostrarnum(clk, sseg, anodos, distance, led, outservo);
    
    input clk; //Reloj
    input [32:0] distance;
    output [0:6] sseg; //7 Segmentos del display
    output reg [5:0] anodos; //Anodos(Selectores del display a usar): NUEVO 6 Ánodos
	 
    reg led1;
	 output led;
	 
	 reg [25:0] outservo1;
	 output [25:0] outservo;
	 
    reg [3:0] bcd; //Posición de los switches(NUMERO INGRESADO)
    reg [3:0] contador; //NUEVO: un contador de 1 a 6

    wire [3:0] dig1 = distance % 10;
	 wire [3:0] dig2 = (distance / 10) % 10 ;
	 wire [3:0] dig3 = (distance / 100) % 10;
	 wire [3:0] dig4 = (distance / 1000) % 10;
	 wire [3:0] dig5 = (distance / 10000) % 10;
	 wire [3:0] dig6 = (distance / 100000) % 10;
    
    
    divfreq D1(clk,clk1);
	 
    sevensegs sev1(bcd, sseg);
    
    
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
	 
	 
	if(dig3==4'b0001)
		led1<=0;
	else
		led1<=1;
			
			
	if (dig2 >= 4'b0001 && dig1 >= 4'b0000)begin // Desde 10cm hasta Max cm, se abre
	
		outservo1<=1;
		
	end
	
	else if (dig2 == 4'b0000 && dig1 <= 4'b1001)begin// Desde 9cm a 0cm, se cierra
	
		outservo1<=0;
	
	end
    
   end
	 
	
	assign led = led1;
	assign outservo = outservo1;
	 
endmodule

/*module shownumber(
	input i_Clk, 
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5,
	input [32:0] num
);

wire [3:0] d0 = num % 10;
wire [3:0] d1 = (num / 10) % 10 ;
wire [3:0] d2 = (num / 100) % 10;
wire [3:0] d3 = (num / 1000) % 10;
wire [3:0] d4 = (num / 10000) % 10;
wire [3:0] d5 = (num / 100000) % 10;

 showdigit cd0 (
	i_Clk,
	d0,
	HEX0
 );
 
 showdigit cd1 (
	i_Clk,
	d1,
	HEX1
 );
 
 showdigit cd2 (
	i_Clk,
	d2,
	HEX2
 );
 
 showdigit cd3 (
	i_Clk,
	d3,
	HEX3
 );
 
 showdigit cd4 (
	i_Clk,
	d4,
	HEX4
 );
 
 showdigit cd5 (
	i_Clk,
	d5,
	HEX5
 );
   
endmodule*/
