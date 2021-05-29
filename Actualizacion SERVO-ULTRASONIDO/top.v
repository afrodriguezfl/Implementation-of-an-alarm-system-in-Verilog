module top(
	input clk,
	output trig, 
	input echo,
	output [6:0] sseg,
	output [5:0] anodos,
	//Servo y led
	output ledsalida,
	output servo
);

  wire [25:0] conexservo; //señal de conexión entre mostrarnum y servoPWM
  wire [32:0] distance;

  sonic sc (
    clk,
	 trig,
	 echo,
	 distance	//salida a mostrarnum
  );
   
mostrarnum mn1 (
	clk,
	sseg,
	anodos,
	distance,	// entrada de distancia de sonid 
	ledsalida,	// señal de salida definitiva (SSD)
	conexservo	// salida a servoPWM
 );
 
 servoPWM sv1(
	clk,
	servo, //señal de salida definitiva (SSD)
	conexservo // entrada de mostrarnum (Sensor de ultrasonido)
	);
endmodule
