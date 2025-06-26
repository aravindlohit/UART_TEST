interface uart_if ( input clk);
 
                    logic         rstn           ;        // Active-low Asynchronous Reset   

                   /* Serial Interface */
                    logic         o_tx            ;      // Serial data out, TX
                   // logic         i_rx            ;       // Serial data in, RX              
                   
                   /* Control Signals */    
                     logic [15:0]  i_baudrate      ;     // Baud rate
                     logic [1:0]   i_parity_mode  ;        // Parity mode
                    logic         i_frame_mode   ;        // Frame mode 
                     logic         i_lpbk_mode_en ;        // Loopback mode enable
                    logic         i_tx_break_en  ;        // Enable to send break frame on TX
                     logic         i_tx_en        ;        // UART TX (Transmitter) enable
                     logic         i_rx_en       ;        // UART RX (Receiver) enable 
                    logic         i_tx_rst       ;        // UART TX reset
                    logic         i_rx_rst       ;        // UART RX reset                
                   
                   /* UART TX Data Interface */    
                    logic [7:0]   i_data         ;       // Parallel data input
                    logic         i_data_valid   ;        // Input data valid
                    logic         o_ready        ;        // Ready signal from UART TX 
                   
                   /* UART RX Data Interface */ 
                    logic [7:0]   o_data         ;        // Parallel data output
                    logic         o_data_valid  ;        // Output data valid
                     logic         i_ready        ;        // Ready signal to UART RX
                   
                   /* Status Signals */   
                    logic         o_tx_state     ;        // State of UART TX (enabled/disabled)
                    logic         o_rx_state     ;        // State of UART RX (enabled/disabled)
                    logic         o_rx_break    ;        // Flags break frame received on RX
                    logic         o_parity_err  ;         // Parity error flag
                   logic         o_frame_err   ;          // Frame error flag                                            


clocking cb@(posedge clk);
  input o_data;
  output i_data;
input o_ready;
input o_data_valid;
input o_tx_state;
output i_baudrate      ;     
  output     i_parity_mode  ;    
 output        i_frame_mode   ;        // Frame mode 
   output         i_lpbk_mode_en ;        // Loopback mode enable
  output         i_tx_break_en  ;        // Enable to send break frame 
   output         i_tx_en        ;        // UART TX (Transmitter)
    output         i_rx_en       ;        // UART RX (Receiver) enable 
    output         i_tx_rst       ;        // UART TX reset
    output         i_rx_rst    ;
  
  output i_data_valid;
output i_ready;
endclocking
				
					
					
clocking mcb@(posedge clk);
  input i_ready;

  input o_data;
					input         o_tx_state     ;        // State of UART TX (enabled/disabled)
                   input         o_rx_state     ;        // State of UART RX (enabled/disabled)
                   input          o_rx_break     ;        // Flags break frame received on RX
                   input          o_parity_err   ;        // Parity error flag
                   input          o_frame_err     ;
endclocking				   
		
		
		
		
//modport tb_modport(clocking cb , output rstn);
//modport tb_mon(clocking mcb);

endinterface

module top();

logic clk;
initial clk=0;
always #50 clk= ~clk; //  core clock - 10 Mhz - 100ns 
  uart_if if_inst(clk);
 


  uart_top uart_inst(    .clk(clk),
                    .rstn(if_inst.rstn),
                    .o_tx(if_inst.o_tx),
                     .i_rx(if_inst.o_tx),
                    
                    
                    .i_baudrate(if_inst.i_baudrate),
                    .i_parity_mode(if_inst.i_parity_mode),
                    .i_frame_mode(if_inst.i_frame_mode),
                     .i_lpbk_mode_en(1'b0),
                     .i_tx_break_en(1'b0),
                    .i_tx_en(if_inst.i_tx_en),
                    .i_rx_en(if_inst.i_rx_en),
                     .i_tx_rst(1'b0),
                     .i_rx_rst(1'b0),
                    
                    
                    .i_data(if_inst.i_data),
                    .i_data_valid(if_inst.i_data_valid),
                    .o_ready(if_inst.o_ready),
                    
                    .o_data(if_inst.o_data),
                    .o_data_valid(if_inst.o_data_valid),
                    .i_ready(if_inst.i_ready),
                    
                    
                    .o_tx_state(if_inst.o_tx_state),
                    .o_rx_state(if_inst.o_rx_state),
                    .o_rx_break(if_inst.o_rx_break),
                    .o_parity_err(if_inst.o_parity_err),
                      .o_frame_err(if_inst.o_frame_err)  ) ;

  testbench tb_inst(.vif(if_inst));


//Section 6: Dumping Waveform
initial begin
  $dumpfile("dump.vcd");
  $dumpvars(0,top.uart_inst); 
end

endmodule
					
