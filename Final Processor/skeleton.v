module skeleton(	resetn,
						inclock,
						KEY, PS2_CLK, PS2_DAT,
						LEDG, LEDR,
						HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
						debug_word, debug_addr,
						debugAddrMasked, debugDataMasked,
						statusRegRdata, fetchInstPC,
						mdException_e_LXM, mdException_LXM_out
						);

	input 			inclock;
	input		[3:0]	KEY;
	inout 			PS2_DAT, PS2_CLK;

	output   [8:0] LEDG;
	output  [17:0] LEDR; 
	output 	[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	
	// dmem writes debug
	output  [31:0] debug_word;
	output  [11:0] debug_addr;
	output  [11:0] debugAddrMasked;   
	output  [31:0] debugDataMasked;
	output  [31:0] statusRegRdata;
	output  [31:0] fetchInstPC;
	output mdException_e_LXM, mdException_LXM_out;
	
	// Processor and ps2 keyboard related
	wire			clock;
	input			resetn;
	wire	[7:0]	ps2_key_data;
	wire			ps2_key_pressed;	// may be used to trigger an interrupt
	wire	[7:0]	ps2_out;
	
	wire [31:0] r1,r9,r10,r11,r12;
	
	// clock divider (50MHz/5=10MHz)
	//pll div(inclock,clock);
	assign clock = inclock;
	
	// your processor
	processor myprocessor(clock, ~resetn, ps2_key_pressed, ps2_out, debug_word, debug_addr, debugAddrMasked, debugDataMasked,
					      statusRegRdata, fetchInstPC, 
						  mdException_e_LXM, mdException_LXM_out,
					      r1, r9, r10, r11, r12);
						 
	// keyboard controller
	PS2_Interface myps2(clock, resetn, PS2_CLK, PS2_DAT, ps2_key_data, ps2_key_pressed, ps2_out);
	
	// registered output
	Hexadecimal_To_Seven_Segment hex6(ps2_out[3:0], HEX6);
	Hexadecimal_To_Seven_Segment hex7(ps2_out[7:4], HEX7);
	
	// the other seven segment displays are currently set to 0
	Hexadecimal_To_Seven_Segment hex0( r9[3:0], HEX0);
	Hexadecimal_To_Seven_Segment hex1(r10[3:0], HEX1);
	Hexadecimal_To_Seven_Segment hex2(r11[3:0], HEX2);
	Hexadecimal_To_Seven_Segment hex3(4'b0, HEX3);
	Hexadecimal_To_Seven_Segment hex4(4'b0, HEX4);
	Hexadecimal_To_Seven_Segment hex5(4'b0, HEX5);
	
	assign LEDG[7:0] = r1[7:0];
	assign LEDR[7:0] = r12[7:0];
 		
endmodule
