module Security_System(clock, on_off, ultras_hub, ultras_else, inWIFI2, outWIFI,LEDS);

	input clock;
	input on_off;
	input ultras_hub;
	input ultras_else;
	input [4:0] inWIFI2;
	
	output outWIFI;
	output reg [3:0]LEDS;
	
	reg init = 0;
	reg [4:0] inWIFI;
	reg [1:0] status;
	reg srn = 0;
	reg send = 0;
	reg lock = 0;
	
	reg [2:0] cmd;

	parameter DESACTIVADO = 'b00;
	parameter ACTIVADO = 'b01;
	parameter ALARMA = 'b10;
	parameter EMERGENCIA = 'b11;

	//assign cmd = (inWIFI=='hA) ?1:0;

	always @(posedge clock)begin 
		if (inWIFI=='ha)
			cmd <= 'b000;// 'b000 = DESACTIVADO	
		else if (inWIFI=='hb)
			cmd <= 'b001;// 'b001 = ACTIVADO	
		else if (inWIFI=='he) 
			cmd <= 'b010;// 'b010 = EMERGENCIA	
		else 
			cmd<= 'b111;
	end

	always @(posedge clock)begin //finite state machine
		 inWIFI <= inWIFI2;
		 init <= on_off;
		 case(status)
			  DESACTIVADO:begin
					LEDS <= 'b0001;
					srn <= 0;
					send <= 0;
					lock <= 0;
					if (init)begin
						 status <= ACTIVADO;
					end
			  end
			  ACTIVADO:begin
					LEDS <= 'b0010;
					srn <= 0;
					send <= 0;
					lock <= 0;
					if ( ultras_else == 1)
						 status <= ALARMA;
					else if (ultras_hub == 1)
						 status <= EMERGENCIA;
			  end
			  ALARMA:begin
					LEDS <= 'b0100;
					srn <= 1;
					send <= 1;
					lock <= 0;
					if (cmd == 'b010)
						status <= EMERGENCIA;
					else if(cmd == 'b001)
						status <= ACTIVADO;
					else if(cmd == 'b000)begin
						init <= 0; 
						status <= DESACTIVADO;
						end
			  end
			  EMERGENCIA:begin
					LEDS <= 'b1000;
					srn <= 1;
					send <= 1;
					lock <= 1;
					if(cmd == 'b001)
						status <= ACTIVADO;
					else if(cmd == 'b000)begin
						init <= 0; 
						status <= DESACTIVADO;
						end
			  end
			  default:
			  status <= DESACTIVADO;
		 endcase
	end
endmodule 