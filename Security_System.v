module Security_System
(
	input wire clk, reset,
	input wire init, utrsnd_hub, utrsnd_else,
	input wire [3:0] inWIFI,
	/*
	output wire outWIFI_g, siren_g, lock_g,
	output reg outWIFI_gf, siren_gf, lock_gf
	*/
	output wire inactive_g, active_g, alarm_g, emergency_g,
	output reg inactive_gf, active_gf, alarm_gf, emergency_gf
);
	
	localparam [1:0]
	INACTIVE  = 2'b00,
	ACTIVE    = 2'b01,
   ALARM     = 2'b10,
   EMERGENCY = 2'b11;
	
	reg[1:0] state, next_state;
	//reg outWIFI, siren, lock;
	reg inactive_o, active_o, alarm_o, emergency_o;

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
		/*
		outWIFI = 1'b0;
		siren   = 1'b0;
		lock    = 1'b0;
		*/
		inactive_o = 1'b1;
		active_o   = 1'b1;
		alarm_o    = 1'b1;
		emergency_o= 1'b1;
		
		case (state)
			INACTIVE : begin
			/*
				outWIFI = 1'b0;
				siren   = 1'b0;
				lock    = 1'b0;
			*/
				inactive_o = 1'b0;
				active_o   = 1'b1;
				alarm_o    = 1'b1;
				emergency_o= 1'b1;
				if (init == 1'b1) begin
						next_state = ACTIVE; 
					end
				else begin 
						next_state = INACTIVE; 
					end
				end
			ACTIVE : begin
			/*
				outWIFI = 1'b1;
				siren   = 1'b1;
				lock    = 1'b1;
			*/
				inactive_o = 1'b1;
				active_o   = 1'b0;
				alarm_o    = 1'b1;
				emergency_o= 1'b1;
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
			/*
				outWIFI = 1'b1;
				siren   = 1'b1;
				lock    = 1'b0;
			*/
				inactive_o = 1'b1;
				active_o   = 1'b1;
				alarm_o    = 1'b0;
				emergency_o= 1'b1;
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
			/*
				outWIFI = 1'b1;
				siren   = 1'b1;
				lock    = 1'b1;
			*/
				inactive_o = 1'b1;
				active_o   = 1'b1;
				alarm_o    = 1'b1;
				emergency_o= 1'b0;
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
			/*
				outWIFI_gf <= 1'b0;
				siren_gf   <= 1'b0;
				lock_gf    <= 1'b0;
			*/
				inactive_gf <= 1'b1;
				active_gf   <= 1'b1;
				alarm_gf    <= 1'b1;
				emergency_gf<= 1'b1;
			end
			else begin
			/*
				outWIFI_gf <= outWIFI;
				siren_gf   <= siren;
				lock_gf    <= lock;
			*/
				inactive_gf <= inactive_o;
				active_gf   <= active_o;
				alarm_gf    <= alarm_o;
				emergency_gf<= emergency_o;
			end
	end
	/*
	assign outWIFI_g = outWIFI; 
	assign siren_g   = siren;
	assign lock_g    = lock;
	*/
	assign inactive_g = inactive_o;
	assign active_g   = active_o;
	assign alarm_g    = alarm_o;
	assign emergency_g= emergency_o;
	
endmodule 