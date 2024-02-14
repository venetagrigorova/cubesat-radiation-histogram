`timescale 1ns / 1ps

module histogram(
	 input wire clk,
    inout wire [7:0] SRAM_IO,
    output wire SRAM_CE,
    output wire SRAM_WE,
    output wire SRAM_OE,
    output wire [20:0] SRAM_A,
    input wire [11:0] TEPC_ADC,
    input wire OR, // Out-of-Range indicator
    input wire DCO, // Data Clock Output	 
	 output wire [7:0] data_at_address,	 
	 output wire data_ready,
	 output wire [2:0] HISTOGRAM_STATE
    );
		
	// FSM State Encoding
  	localparam	S_IDLE = 0,					
					S_setSRAMread = 1,
					S_incrementValue = 2,
					S_setSRAMwrite = 3,
					S_stopSRAMwrite = 4;
					
	// Signal Declaration
	reg [2:0] HISTOGRAM_STATE_reg = 0, HISTOGRAM_STATE_next = 0;
	reg [7:0] SRAM_IO_reg = 0, SRAM_IO_next = 0;
	reg SRAM_CE_reg = 0, SRAM_CE_next = 0;
	reg SRAM_WE_reg = 0, SRAM_WE_next = 0;
	reg SRAM_OE_reg = 0, SRAM_OE_next = 0;
	reg [20:0] SRAM_A_reg = 0, SRAM_A_next = 0;
	reg [11:0] TEPC_ADC_reg = 0, TEPC_ADC_next = 0;
	reg [7:0] data_at_address_reg = 0, data_at_address_next = 0;
	reg data_ready_reg = 0, data_ready_next = 0;
	
	// Updating Registers
	always @ (posedge clk) begin
		HISTOGRAM_STATE_reg <= HISTOGRAM_STATE_next;
		SRAM_IO_reg <= SRAM_IO_next;
		SRAM_CE_reg <= SRAM_CE_next;
		SRAM_WE_reg <= SRAM_WE_next;
		SRAM_OE_reg <= SRAM_OE_next;
		SRAM_A_reg <= SRAM_A_next;
		TEPC_ADC_reg <= TEPC_ADC_next;
		data_at_address_reg <= data_at_address_next;
		
	end
	
	always @ * begin
		HISTOGRAM_STATE_next = S_IDLE;
		SRAM_OE_next = 1'd0; //active high
		SRAM_WE_next = 1'd1; //active low
		data_ready_next = 1'd0; //active high
	
		case(HISTOGRAM_STATE_reg)
			S_IDLE: begin
				if (DCO == 1'b1) begin
					TEPC_ADC_next = TEPC_ADC;
					HISTOGRAM_STATE_next = S_setSRAMread;
				end
			end
			
			S_setSRAMread: begin
				SRAM_A_next = {9'd0, TEPC_ADC_reg}; // concatenate 9 zeros to ADC value for 21 bit SRAM address			
				HISTOGRAM_STATE_next = S_incrementValue;
			end
			
			S_incrementValue: begin
				data_at_address_next = SRAM_IO;
				data_ready_next = 1'd1;
				SRAM_IO_next = SRAM_IO + 1'b1; // increment value currently in SRAM			
				HISTOGRAM_STATE_next = S_setSRAMwrite;
			end
			
			S_setSRAMwrite: begin
				SRAM_OE_next = 1'd1; // disable output
				SRAM_WE_next = 1'd0; // enable write		
				HISTOGRAM_STATE_next = S_stopSRAMwrite;
			end
			
			S_stopSRAMwrite: begin
				SRAM_WE_next = 1'd1; // disable write		
				HISTOGRAM_STATE_next = S_IDLE;
			end
			
		endcase
	end
	
	assign HISTOGRAM_STATE = HISTOGRAM_STATE_reg;
	assign SRAM_CE = 1'd0; // enable chip		
	assign SRAM_IO = (~SRAM_OE_reg) ? 8'bZ : SRAM_IO_reg;
	
	assign SRAM_WE = SRAM_WE_reg;
	assign SRAM_OE = SRAM_OE_reg;
	assign SRAM_A = SRAM_A_reg;

	assign data_at_address = data_at_address_reg;
	assign data_ready = data_ready_next;

endmodule
