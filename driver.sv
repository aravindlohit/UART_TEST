class driver;
  
 bit [15:0] packets   = 16'd5;
transaction tr;
mailbox#(transaction) mbx;
//generator gen;
  //gen=new();
virtual interface uart_if  vif;
  ///event next;
  logic [7:0] tx_data;
  int tx_packet_count;
  int UART_PACKETS    = 256 ;
  logic tx_break_en = 1'b0;

//function void new
  function new(input mailbox#(transaction) mbx );
this.mbx=mbx;
    //gen=new(mbx);
  //tr=new();
endfunction
  
  
  
  task run();
    TX_initial();
    TX_DRIVE();
  endtask
  
  
  task drive_reset();
  
vif.rstn<=1'b0;
//vif.cb.i_rx_rst<=1'b1;
//vif.cb.i_tx_rst<=1'b1;
$display("driver - reset is asserted at time =%0t",$time);
  repeat(15)@(vif.cb);
vif.rstn<=1'b1;
//vif.cb.i_rx_rst<=1'b0;
//vif.cb.i_tx_rst<=1'b0;
  $display("driver- reset released after 15 clock cycles at time=%0t",$time);
endtask
  
  
  
   task TX_initial();
    //mbx.get(tr);
    vif.cb.i_baudrate<=int'((10000000/tr.BAUDRATE)/8.0-1);
    vif.cb.i_parity_mode<=tr.PARITY_MODE;
    vif.cb.i_frame_mode<=tr.FRAME_MODE;
    vif.cb.i_tx_en<=tr.TX_EN;
    vif.cb.i_rx_en<=tr.RX_EN ;
    
$display ("UART initialized in following configuration:") ;
   $display ("--------------------------------------------") ;
    $display ("Baud rate   : %0d", tr.BAUDRATE, " bps")  ;
    
    if (tr.PARITY_MODE == 2'b00) begin
      $display ("Parity mode : No Parity")                   ;
   end
    else if (tr.PARITY_MODE == 2'b01) begin
      $display ("Parity mode : Odd Parity")                  ;   	
   end
    else if (tr.PARITY_MODE == 2'b11) begin
      $display ("Parity mode : Even Parity")                 ;         	
   end
   else begin
      $display ("Parity mode : ** ERROR **")                 ;     	
   end

    if (tr.FRAME_MODE == 0) begin
      $display ("Frame mode  : 1 Start bit, 1 Stop bit")     ;
   end
    else if (tr.FRAME_MODE == 1) begin
      $display ("Frame mode  : 1 Start bit, 2 Stop bits")    ;   	
   end        
   else begin
      $display ("Frame mode  : ** ERROR **")                 ;     	
   end
    
    if (tr.TX_EN) begin
      $display ("TX enabled  : YES")                         ;
   end
   else begin
   	$display ("TX enabled  : NO")                          ;
   end

    if (tr.RX_EN) begin
      $display ("RX enabled  : YES")                         ;
   end
   else begin
   	$display ("RX enabled  : NO")                          ;
     $display ("")  ;
   end
    
  endtask
  
  
  
  
  
  task TX_DRIVE();
    begin
    if (vif.cb.o_ready == 1'b1 && tx_packet_count < UART_PACKETS) 
      begin
          
          // Send data
      @ (vif.cb)
   vif.cb.i_data      <= tx_data ;
   vif.cb.i_tx_break_en <= tx_break_en  ;
   vif.cb.i_data_valid <= 1'b1     ;

      @ (vif.cb)            
   vif.cb.i_data_valid <= 1'b0     ;

          // Messages
          $display (" ") ;
          $display ("Sent data     = %0d @time = %0t", tx_data, $time) ;
          $display (" ") ;
          
          // Update data
          tx_break_en     = tx_break_en ? 1'b0 : (tx_data % 8 == 0) && (tx_data != 0) ;  // Send break after 8 packets
          tx_data         = tx_break_en ? tx_data : (tx_data + 1)                     ;
          tx_packet_count = tx_break_en ? tx_packet_count : (tx_packet_count+1)     ;

       end       
    end
  endtask
    
 
 
 endclass
