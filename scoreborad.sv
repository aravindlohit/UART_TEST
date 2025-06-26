class scoreboard;
  transaction tr;
 driver drv;
//generator gen;
  mailbox#(transaction) mbx;
  virtual interface uart_if vif;
    int rx_packet_count;
    logic [7:0] rx_data;
    logic dstatus;
    logic pstatus;
    logic rx_break;
    logic fstatus;
    logic [7  : 0] rx_data_exp     ;
    
  function new( mailbox#(transaction) mbx );
this.mbx=mbx;
 tr=new();
    drv=new(mbx);
    //gen=new(mbx);
endfunction
    
    
    task run();
      begin
        
      if (vif.cb.o_data_valid) begin
          
          // Receive data
          vif.cb.i_ready <= 1'b1   ;
      
        @ (vif.cb)
   vif.cb.i_ready <= 1'b0   ;

   rx_data = vif.cb.o_data    ;
   pstatus  = vif.mcb.o_parity_err ;
   fstatus  = vif.mcb.o_frame_err  ;

          // Messages
          $display (" ") ;
          $display ("Received data = %0d @time = %0t", rx_data, $time) ;
      end
          
          // Data validation          
          if (rx_data == rx_data_exp) begin
             dstatus     = 1'b0                   ;
             rx_data_exp = rx_data_exp + 1        ;          	
             $display ("Data status   = SUCCESS") ;
          end
          //else if ((rx_packet_count == UART_PACKETS -1) && (rx_data == tx_data - 2'h1)) begin
             //dStatus = 1'b0                       ;          	
             //$display ("Data status   = SUCCESS") ;
          //end
          else begin
            if (!vif.mcb.o_rx_break) begin           
                dstatus = 1'b1                       ;  
                rx_data_exp = rx_data_exp + 1        ;        	
                $display ("Data status   = FAIL")    ; 
             end
             else begin
                dstatus = 1'b0 ;  
                $display ("Data status   = BREAK") ;  
             end         	
          end
          
          // Parity validation
        if (!pstatus) begin
             $display ("Parity status = SUCCESS") ; 
          end
          else begin
             $display ("Parity status = FAIL")    ;                      	
          end

        if (!fstatus) begin
             $display ("Frame status  = SUCCESS") ; 
          end
          else begin
             $display ("Frame status  = FAIL")    ;                                 	
          end

          $display (" ") ; 
          
          // Update packet count
          rx_packet_count = rx_break ? rx_packet_count : (rx_packet_count + 1) ;
          
          // Test report for FAIL
        if (pstatus || (fstatus && !rx_break) || dstatus) begin  // For break frame reception, frame error always happen, so this can be ignored...

             $display (" ") ;    
             $display ("UART Test Report")                                ;
             $display ("----------------")                                ;     	
          $display ("Sent     : %0d packets", drv.tx_packet_count)         ;
          $display ("Received : %0d packets", rx_packet_count)         ;
             $display ("Error in UART packet reception, test failed !!!") ;
             $display (" ") ;          	
             //$finish ; 

          end         
          
          // Test Report for SUCCESS
        if (rx_packet_count == drv.UART_PACKETS) begin

             $display (" ") ; 
             $display ("UART Test Report")                                    ;
             $display ("----------------")                                    ;          	
          $display ("Sent     : %0d packets", drv.tx_packet_count)             ;
             $display ("Received : %0d packets", rx_packet_count)             ;
             $display ("No errors in UART packet reception, test passed !!!") ; 
             $display (" ") ;
             //$finish ;  
                    	
          end

      end
     
      
    endtask
    
    endclass
