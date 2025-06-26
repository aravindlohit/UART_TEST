class generator;
event next;
transaction tr;
mailbox#(transaction) mbx;
  bit [15:0] packets   = 16'd5;

  bit [3:0] count=3'b101;
event done;
event drive ;
   event  sconext;
  //event next;
  function  new( mailbox#(transaction) mbx);
this.mbx=mbx;
tr=new();
endfunction

 task run();
   //tr=new();
   
   repeat(packets) begin
    
assert(tr.randomize());
 //tr=new();
//tr.kind=config_tx_rx;
//tr.i_parity_mode =2'b01;
//tr.i_lpbk_mode_en=1;
    $display("i_data is randomized --%d ",tr.i_data);
mbx.put(tr);
     //@ (drive);
     //@(sconext);

  end 
   //-> done;
endtask

endclass
