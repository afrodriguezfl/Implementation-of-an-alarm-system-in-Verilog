module Security_Control
(
	////////////////FSM/////////////////////
		input  i_Clk,       		// Main Clock
  
		input [3:0] i_Col,   	// Mapped to Columns
		output [3:0] o_Row,   	// Mapped to Rows

		input wire reset,
		input wire init,
		input wire [1:0] i_WIFI,
		output reg [2:0] outWIFI_gf,
		output o_buzzer,
		output [11:0] o_LEDs,
	
	////////////////LCD/////////////////////
		inout [7:0] LCD_DATA,
		output LCD_RW,
		output LCD_EN,
		output LCD_RS,
	////////////////////////////////////////

	// 7-Segment Displays, Segment1 is upper digit
	
		output [0:6] o_7Segments,
		output [7:0] o_Anodos
);

	reg [2:0] outWIFI;
	reg [1:0] message;
	wire [3:0] o_Code;
	reg r_buzzer, r_leds;

	localparam [2:0]
	NEUTRAL   = 3'b000,
	INACTIVE  = 3'b001,
   ACTIVE    = 3'b010,
   ALARM     = 3'b011,
	EMERGENCY = 3'b100;
	
	reg [2:0] state, next_state;


	Keypad_state_machine keypad_Inst
		(.i_Clk(i_Clk),
		.i_Col(i_Col),
		.o_Row(o_Row),
		.o_7Segments(o_7Segments),
		.o_Anodos(o_Anodos),
		.w_Decode_Out(o_Code)
		);
		
	LCD_Top LCD_Inst
		(.MESG(message),
		.CLOCK_50(i_Clk),
		.LCD_RW(LCD_RW),
		.LCD_EN(LCD_EN),
		.LCD_RS(LCD_RS),
		.LCD_DATA(LCD_DATA)
		);
	
	Buzzer_alarm Buzzer_Inst(
		.clk(i_Clk),
		.aux(r_buzzer),
		.speaker(o_buzzer)
		);
	
	Led_alarm Alarm_Inst(
        .clk(i_Clk),
        .aux(r_leds),
        .LEDR(o_LEDs)
    );
		
	always @(i_Clk)
	begin
			
			if(message == 2'b10 || message == 2'b11)begin
				r_buzzer <= 1;
				r_leds <= 1;
			end
			else begin
				r_buzzer <= 0;// prueba para evitar constante
				r_leds <=0;
			end
			
	end

	
	always @(posedge i_Clk, posedge reset)
	begin
		if (reset) begin
			state <= NEUTRAL;
		end
		else begin
			state <= next_state;
		end
	end


	always @(init, o_Code, state) begin 

		next_state = state;
		
		case (state)
		
			NEUTRAL : begin 
				
				outWIFI = 3'b001;
			
				if (init == 1'b1 && o_Code == 4'b0001) begin
						next_state = INACTIVE; 
					end
				else if (init == 1'b1 && o_Code == 4'b1011) begin
						next_state = ACTIVE; 
					end
				else if (init == 1'b1 && o_Code == 4'b0101) begin
						next_state = ALARM; 
					end
				else if (init == 1'b1 && o_Code == 4'b1101) begin
						next_state = EMERGENCY; 
					end
				else begin 
						next_state = NEUTRAL; 
					end
			end
		
			INACTIVE : begin
			
				outWIFI = 3'b000;
				
				if (init == 1'b1 && o_Code == 4'b0000) begin
						next_state = NEUTRAL; 
					end
				else if (init == 1'b1 && o_Code == 4'b1011) begin
						next_state = ACTIVE; 
					end
				else if (init == 1'b1 && o_Code == 4'b0101) begin
						next_state = ALARM; 
					end
				else if (init == 1'b1 && o_Code == 4'b1101) begin
						next_state = EMERGENCY; 
					end
				else begin 
						next_state = INACTIVE; 
					end
			end
				
			ACTIVE : begin
				
				outWIFI = 3'b010;
								
				if (init == 1'b1 && o_Code == 4'b0000) begin
						next_state = NEUTRAL; 
					end
				else if (init == 1'b1 && o_Code == 4'b0001) begin
						next_state = INACTIVE; 
					end
				else if (init == 1'b1 && o_Code == 4'b0101) begin
						next_state = ALARM; 
					end
				else if (init == 1'b1 && o_Code == 4'b1101) begin
						next_state = EMERGENCY; 
					end
				else begin 
						next_state = ACTIVE; 
					end
				
			end
				
			ALARM : begin
		
				outWIFI = 3'b100;
				
				if (init == 1'b1 && o_Code == 4'b0000) begin
						next_state = NEUTRAL; 
					end
				else if (init == 1'b1 && o_Code == 4'b0001) begin
						next_state = INACTIVE; 
					end
				else if (init == 1'b1 && o_Code == 4'b1011) begin
						next_state = ACTIVE; 
					end
				else if (init == 1'b1 && o_Code == 4'b1101) begin
						next_state = EMERGENCY; 
					end
				else begin 
						next_state = ALARM; 
					end
	
			end
				
			EMERGENCY : begin

				outWIFI = 3'b110;
				
				if (init == 1'b1 && o_Code == 4'b0000) begin
						next_state = NEUTRAL; 
					end
				else if (init == 1'b1 && o_Code == 4'b0001) begin
						next_state = INACTIVE; 
					end
				else if (init == 1'b1 && o_Code == 4'b1011) begin
						next_state = ACTIVE; 
					end
				else if (init == 1'b1 && o_Code == 4'b0101) begin
						next_state = ALARM; 
					end
				else begin 
						next_state = EMERGENCY; 
					end
				
			end
	
		endcase
		 
	end  
	
	always @(posedge i_Clk, posedge reset) begin 
			if (reset) begin
				outWIFI_gf <= 3'b111;
			end
			else begin
				outWIFI_gf <= outWIFI;
			end
	end

	always @(posedge i_Clk)
	begin
		case (i_WIFI)
		
			2'b00: message <= 2'b01;
			2'b01: message <= 2'b10;
			2'b10: message <= 2'b11;
			2'b11: message <= 2'b00; 
			
		endcase	
	end
	
endmodule 
