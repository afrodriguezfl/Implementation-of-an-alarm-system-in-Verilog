module Security_System
(

	////////////////FSM/////////////////////
		input wire clk, reset,
		input wire init, //utrsnd_else,
		input wire [3:0] inWIFI,
		input wire [2:0] inWIFI2,
		
		output reg outWIFI_gf, outWIFI2_gf, siren_gf, lock_gf, 
		output reg inactive_gf, active_gf, alarm_gf, emergency_gf, // validation variables
	////////////////////////////////////////	
	
	////////////////LCD/////////////////////
		inout [7:0] LCD_DATA,
		output LCD_RW,
		output LCD_EN,
		output LCD_RS,
		output reg [1:0] message_gf,
	////////////////////////////////////////
	
	///////////SENSORES Y SERVO/////////////
		input echo, echo1,
		output trig, trig1,
		output [6:0] sseg,
		output[6:0] sseg1,//[6:0] sseg1 no se conecta a nada
		output [7:0] anodos,//output [5:0] anodos
		output ledsalida, ledsalida1,
		output servo,buzzer1, LEDsys
		
	////////////////////////////////////////
		
);
	
	localparam [1:0]
	INACTIVE  = 2'b00,
	ACTIVE    = 2'b01,
   ALARM     = 2'b10,
   EMERGENCY = 2'b11;

	reg [1:0] state, next_state, message;
	reg outWIFI, outWIFI2, siren, lock, clksirena, alarmsig;
	reg inactive_o, active_o, alarm_o, emergency_o;
	
	LCD_Top lcd(.MESG(message_gf),.CLOCK_50(clk),.LCD_RW(LCD_RW),.LCD_EN(LCD_EN),.LCD_RS(LCD_RS),.LCD_DATA(LCD_DATA));
	
	//wire conexservo; //señal de conexión entre mostrarnum y servoPWM
	wire [32:0] distance;
	wire utrsnd_hub;
	wire utrsnd_else;
	//wire sirena;
	
	sonic scHUB(
		clk,
		echo,//49
		trig,//42
		sseg,
		anodos [3:0],// anodos
		ledsalida,
		utrsnd_hub
	);

	sonic scELSE1(
		clk,
		echo1,//50
		trig1,//43
		sseg1,
		anodos [7:4],// anodos
		ledsalida1,
		utrsnd_else
	);
	
	servoPWM sv(
		clk,
		servo, //señal de salida definitiva (SSD)
		lock_gf// entrada de mostrarnum (Sensor de ultrasonido)
	);
	
	buzzeralarm bz(
		clk,
		clksirena,
		buzzer1
		);
		
	ledAlarm al(
		clk,
		alarmsig,
		LEDsys
);
		
	always @(clk)
	begin
			
			if(state==ALARM || state==EMERGENCY)begin
				clksirena <= 1;
				alarmsig <= 1;
			end
			else begin
				clksirena <= 0;// prueba para evitar constante
				alarmsig <=0;
			end
			
	end
	
	
	always @(posedge clk, posedge reset)
	begin
		if (reset) begin
			state <= INACTIVE;
		end
		else begin
			state <= next_state;
		end
	end
	
	always @(init, utrsnd_hub, utrsnd_else, inWIFI, inWIFI2, state) begin 

		next_state = state;
		outWIFI = 1'b1;
		outWIFI2 = 1'b1;
		siren   = 1'b0;
		lock    = 1'b0;
		inactive_o  = 1'b1;
		active_o    = 1'b1;
		alarm_o     = 1'b1;
		emergency_o = 1'b1;
		message = 2'b00;
		
		case (state)
		
			INACTIVE : begin
				outWIFI = 1'b1;
				outWIFI2 = 1'b1;
				siren   = 1'b0;
				lock    = 1'b0;
				inactive_o  = 1'b0;
				active_o    = 1'b1;
				alarm_o     = 1'b1;
				emergency_o = 1'b1;
				message = 2'b00;
				
				if (init == 1'b1 || (inWIFI2[1] == 0 && inWIFI2[0] == 1)) begin
						next_state = ACTIVE; 
					end
				else begin 
						next_state = INACTIVE; 
					end
			end
				
			ACTIVE : begin
				outWIFI = 1'b1;
				outWIFI2 = 1'b0;
				siren   = 1'b0;
				lock    = 1'b0;
				inactive_o  = 1'b1;
				active_o    = 1'b0;
				alarm_o     = 1'b1;
				emergency_o = 1'b1;
				message = 2'b01;
				
				
				if (utrsnd_else == 1'b1 || inWIFI2[2]==1) begin
						next_state = ALARM; 
					end
				else if (utrsnd_hub == 1'b1 || (inWIFI2[1] == 1 && inWIFI2[0] == 1)) begin
						next_state = EMERGENCY; 
					end
				else begin 
						next_state = ACTIVE; 
					end
					// || inWIFI2 == 3'b111
			end
				
			ALARM : begin
				outWIFI = 1'b0;
				outWIFI2 = 1'b1;
				siren   = 1'b1;
				lock    = 1'b0;
				inactive_o  = 1'b1;
				active_o    = 1'b1;
				alarm_o     = 1'b0;
				emergency_o = 1'b1;
				message = 2'b10;
				
				// Comprobar si ultrasonido hub está activo.
				if (inWIFI == 4'b1010 || (inWIFI2[1] == 1 && inWIFI2[0] == 0)) begin	//inWIFI[2]=111 INACTIVE
						next_state = INACTIVE; 
					end
				else if (inWIFI == 4'b1011 || (inWIFI2[1] == 0 && inWIFI2[0] == 1)) begin
						next_state = ACTIVE; 						//inWIFI[2]=001 ACTIVE
					end													//inWIFI[2]=010 ALARM
				else if (inWIFI == 4'b1100 || utrsnd_hub == 1'b1 || (inWIFI2[1] == 1 && inWIFI2[0] == 1)) begin 
						next_state = EMERGENCY; 					//inWIFI[2]=011 EMERGENCY
					end
				else begin 
						next_state = ALARM; 
					end
					
					
			end
				
			EMERGENCY : begin
				outWIFI = 1'b0;
				outWIFI2 = 1'b0;
				siren   = 1'b1;
				lock    = 1'b1;
				inactive_o  = 1'b1;
				active_o    = 1'b1;
				alarm_o     = 1'b1;
				emergency_o = 1'b0;
				message = 2'b11;
				if (inWIFI == 4'b1010 || (inWIFI2[1] == 1 && inWIFI2[0] == 0)) begin
						next_state = INACTIVE; 
					end
				else if (inWIFI == 4'b1011 || (inWIFI2[1] == 0 && inWIFI2[0] == 1)) begin
						next_state = ACTIVE; 
					end
                             //Agregar EMERGENCY -> ALARM (inWIFI) 
				else begin 
						next_state = EMERGENCY; 
					end
			end
	
		endcase
		 
	end  
	
	always @(posedge clk, posedge reset) begin 
			if (reset) begin
				outWIFI_gf <= 1'b1;
				outWIFI2_gf <= 1'b1;
				siren_gf   <= 1'b0;
				lock_gf    <= 1'b0;
				inactive_gf  <= 1'b1;
				active_gf    <= 1'b1;
				alarm_gf     <= 1'b1;
				emergency_gf <= 1'b1;
				message_gf <= 2'b00;
				
			end
			else begin
				outWIFI_gf <= outWIFI;
				outWIFI2_gf <= outWIFI2;
				siren_gf   <= siren;
				lock_gf    <= lock;
				inactive_gf  <= inactive_o;
				active_gf    <= active_o;
				alarm_gf     <= alarm_o;
				emergency_gf <= emergency_o;
				message_gf <= message;
			end
	end

endmodule 


/*
module Security_System
(

	////////////////FSM/////////////////////
		input wire clk, reset,
		input wire init, utrsnd_else,
		input wire [3:0] inWIFI,

		output reg outWIFI_gf, siren_gf, lock_gf, 
		output reg inactive_gf, active_gf, alarm_gf, emergency_gf, // validation variables
	////////////////////////////////////////	
	
	////////////////LCD/////////////////////
		inout [7:0] LCD_DATA,
		output LCD_RW,
		output LCD_EN,
		output LCD_RS,
		output reg [1:0] message_gf,
	////////////////////////////////////////
	
	///////////SENSORES Y SERVO/////////////
		input echo,
		output trig, 
		output [6:0] sseg,
		output [5:0] anodos,
		output ledsalida,
		output servo
	////////////////////////////////////////
		
);
	
	localparam [1:0]
	INACTIVE  = 2'b00,
	ACTIVE    = 2'b01,
   ALARM     = 2'b10,
   EMERGENCY = 2'b11;

	reg [1:0] state, next_state, message;
	reg outWIFI, siren, lock;
	reg inactive_o, active_o, alarm_o, emergency_o;

	LCD_Top lcd(.MESG(message_gf),.CLOCK_50(clk),.LCD_RW(LCD_RW),.LCD_EN(LCD_EN),.LCD_RS(LCD_RS),.LCD_DATA(LCD_DATA));
	
	//wire conexservo; //señal de conexión entre mostrarnum y servoPWM
	wire [32:0] distance;
	wire utrsnd_hub;
	//wire utrsnd_else;
	
	sonic scHUB(
		clk,
		echo,
		trig,
		sseg,
		anodos,
		ledsalida,
		utrsnd_hub
	);

//	sonic scELSE1(
//		clk,
//		echo,
//		trig,
//		sseg,
//		anodos,
//		ledsalida,
//		utrsnd_else
//	);
	
	servoPWM sv(
		clk,
		servo, //señal de salida definitiva (SSD)
		lock_gf// entrada de mostrarnum (Sensor de ultrasonido)
	);

	always @(posedge clk, posedge reset)
	begin
		if (reset) begin
			state <= INACTIVE;
		end
		else begin
			state <= next_state;
		end
	end
	
	always @(init, utrsnd_hub, utrsnd_else, inWIFI, state) begin 

		next_state = state;
		outWIFI = 1'b0;
		siren   = 1'b0;
		lock    = 1'b0;
		inactive_o  = 1'b1;
		active_o    = 1'b1;
		alarm_o     = 1'b1;
		emergency_o = 1'b1;
		message = 2'b00;
		
		case (state)
		
			INACTIVE : begin
				outWIFI = 1'b0;
				siren   = 1'b0;
				lock    = 1'b0;
				inactive_o  = 1'b0;
				active_o    = 1'b1;
				alarm_o     = 1'b1;
				emergency_o = 1'b1;
				message = 2'b00;
				if (init == 1'b1) begin
						next_state = ACTIVE; 
					end
				else begin 
						next_state = INACTIVE; 
					end
			end
				
			ACTIVE : begin
				outWIFI = 1'b0;
				siren   = 1'b0;
				lock    = 1'b0;
				inactive_o  = 1'b1;
				active_o    = 1'b0;
				alarm_o     = 1'b1;
				emergency_o = 1'b1;
				message = 2'b01;
				if (utrsnd_else == 1'b1) begin
						next_state = ALARM; 
					end
				else if (utrsnd_hub == 1'b1) begin
						next_state = EMERGENCY; 
					end
				else begin 
						next_state = ACTIVE; 
					end
			end
				
			ALARM : begin
				outWIFI = 1'b1;
				siren   = 1'b1;
				lock    = 1'b0;
				inactive_o  = 1'b1;
				active_o    = 1'b1;
				alarm_o     = 1'b0;
				emergency_o = 1'b1;
				message = 2'b10;
				if (inWIFI == 4'b1010) begin
						next_state = INACTIVE; 
					end
				else if (inWIFI == 4'b1011) begin
						next_state = ACTIVE; 
					end
				else if (inWIFI == 4'b1100) begin 
						next_state = EMERGENCY; 
					end
				else begin 
						next_state = ALARM; 
					end
			end
				
			EMERGENCY : begin
				outWIFI = 1'b1;
				siren   = 1'b1;
				lock    = 1'b1;
				inactive_o  = 1'b1;
				active_o    = 1'b1;
				alarm_o     = 1'b1;
				emergency_o = 1'b0;
				message = 2'b11;
				if (inWIFI == 4'b1010) begin
						next_state = INACTIVE; 
					end
				else if (inWIFI == 4'b1011) begin
						next_state = ACTIVE; 
					end
				else begin 
						next_state = EMERGENCY; 
					end
			end
	
		endcase
		 
	end  
	
	always @(posedge clk, posedge reset) begin 
			if (reset) begin
				outWIFI_gf <= 1'b0;
				siren_gf   <= 1'b0;
				lock_gf    <= 1'b0;
				inactive_gf  <= 1'b1;
				active_gf    <= 1'b1;
				alarm_gf     <= 1'b1;
				emergency_gf <= 1'b1;
				message_gf <= 2'b00;
			end
			else begin
				outWIFI_gf <= outWIFI;
				siren_gf   <= siren;
				lock_gf    <= lock;
				inactive_gf  <= inactive_o;
				active_gf    <= active_o;
				alarm_gf     <= alarm_o;
				emergency_gf <= emergency_o;
				message_gf <= message;
			end
	end

endmodule 
*/