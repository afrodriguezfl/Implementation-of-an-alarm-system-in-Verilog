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
	
  wire conexservo; //señal de conexión entre mostrarnum y servoPWM
  wire [32:0] distance;

	sonic sc(
		clk,
		echo,
		trig,
		sseg
		anodos
		ledsalida
		conexservo
	);

	servoPWM sv(
		clk,
		servo, //señal de salida definitiva (SSD)
		conexservo // entrada de mostrarnum (Sensor de ultrasonido)
	);
endmodule
