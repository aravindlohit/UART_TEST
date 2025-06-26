class transaction;

//TX Data interface//

//tr_type kind;

 rand bit [7:0]  i_data;
   bit [7:0]  o_data;

bit [2:0]  NO_PARITY       = 2'b00                            ;        // No parity mode
bit [2:0] ODD_PARITY      = 2'b01                            ;     
  
  // Odd parity mode
bit [2:0] EVEN_PARITY     = 2'b11                            ;        // Even parity mode
bit  S_S             = 0                                ;        // 1 Start, 1 Stop bit mode
bit S_SS            = 1 ;
 
 
  
  
  bit [15:0]  BAUDRATE        = 16'd115200                           ;        // Baud rate; Max. value = SYS_CLK/16
 rand  bit [2:0] PARITY_MODE                           ; 
  constraint parity {PARITY_MODE inside {0,1,3};}// Parity mode : NO_PARITY, ODD_PARITY, EVEN_PARITY
bit  FRAME_MODE      = 0                              ;        // Frame mode  : S_S, S_SS
bit TX_EN           = 1                                ;        // '1' to enable UART TX
bit RX_EN           = 1                                ;        // '1' to enable UART RX
bit INT_LPBK_EN     = 1'b0                             ;        // '1' to enable internal loopback
 // bit [15:0] packets   = 16'd5 ;
  
  
endclass
 
