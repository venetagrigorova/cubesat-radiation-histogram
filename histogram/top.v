`timescale 1ns / 1ps

module top(

		// 100 MHz Differential Clock
		input wire SYSCLK_P, SYSCLK_N,
		
		//SRAM Cpntrol
		inout wire [7:0] SRAM_IO,
		output wire SRAM_CE,
		output wire SRAM_WE,
		output wire SRAM_OE,
		output wire [20:0] SRAM_A,
		
		//ADC Control
		input wire [11:0] TEPC_ADC,
		input wire OR, // Out-of-Range indicator
		input wire DCO // Data Clock Output

    );

		wire clk;
		
		IBUFGDS clkInst (.O  (clk),
								.I  (SYSCLK_P),
								.IB (SYSCLK_N));

		histogram histogramInst (.clk (clk),
											.SRAM_IO (SRAM_IO),
											.SRAM_CE (SRAM_CE),
											.SRAM_WE (SRAM_WE),
											.SRAM_OE (SRAM_OE),
											.SRAM_A (SRAM_A),
											.TEPC_ADC (TEPC_ADC),
											.OR (OR),
											.DCO (DCO)
											);
																				

endmodule
