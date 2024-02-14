`timescale 1ns / 1ps

module histogram_tb;

	// Inputs
	reg clk;
	reg [11:0] TEPC_ADC;
	reg OR;
	reg DCO;
	
	// Outputs
	wire SRAM_CE;
	wire SRAM_WE;
	wire SRAM_OE;
	wire [20:0] SRAM_A;
	wire [2:0] HISTOGRAM_STATE;

	// Bi Directionals
	wire [7:0] SRAM_IO;

	// Instantiate the Unit Under Test (UUT)
	histogram uut (
		.clk(clk), 
		.SRAM_IO(SRAM_IO), 
		.SRAM_CE(SRAM_CE), 
		.SRAM_WE(SRAM_WE), 
		.SRAM_OE(SRAM_OE), 
		.SRAM_A(SRAM_A), 
		.TEPC_ADC(TEPC_ADC), 
		.OR(OR), 
		.DCO(DCO),
		.HISTOGRAM_STATE(HISTOGRAM_STATE)
	);

	always begin
		#0.5 clk = !clk;
	end

	initial begin
		// Initialize Inputs		
		TEPC_ADC = 12'd0;
		OR = 0;
		DCO = 1'b1;
		clk = 0;
		
		// Wait 100 ns for global reset to finish
		#100;
		
		// End Simulation
		#1000 $finish;
	end
	
	// Add stimulus here
	always @ (posedge clk) begin
		DCO = ~DCO;
		TEPC_ADC = $random;
	end
	
	assign SRAM_IO = (SRAM_OE) ? 8'bZ : 0;
			
endmodule

