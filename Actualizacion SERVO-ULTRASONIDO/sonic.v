module sonic(

		input clock,
		input echo, 
		output trig,
		output [0:6] sseg,       //7 Segmentos del display
		output [5:0] anodos, //Anodos(Selectores del display a usar): NUEVO 6 Ánodos
		output ledout, 
		output outservo

);

	reg _trig = 1'b0;
	reg [32:0] distance;
	reg [32:0] us_counter = 0;
	reg [9:0] one_us_cnt = 0;
	reg [9:0] ten_us_cnt = 0;
	reg [21:0] forty_ms_cnt = 0;
	
	wire one_us = (one_us_cnt == 0);
	wire ten_us = (ten_us_cnt == 0);
	wire forty_ms = (forty_ms_cnt == 0);

	assign trig = _trig;
	
	mostrarnum mn(
		clock,
		distance,	// Entrada de distancia de sonido
		sseg,
		anodos,
		ledout,	   // Señal de salida definitiva (SSD)
		outservo	   // Salida a servoPWM
	);

	always @(posedge clock) begin

		one_us_cnt <= (one_us ? 50 : one_us_cnt) - 1;
		ten_us_cnt <= (ten_us ? 500 : ten_us_cnt) - 1;
		forty_ms_cnt <= (forty_ms ? 2000000 : forty_ms_cnt) - 1;
		
		if (ten_us && _trig)
			_trig <= 1'b0;
		
		if (one_us) begin	
			if (echo)
				us_counter <= us_counter + 1;
			else if (us_counter) begin
				distance <= us_counter / 58;
				us_counter <= 0;
			end
		end
		
		if (forty_ms)
			_trig <= 1'b1;
	end

endmodule
