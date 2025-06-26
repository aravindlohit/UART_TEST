class environment;

  transaction tr;
  driver drv;
  scoreboard sco;
  mailbox#(transaction) mbx;

  virtual uart_if vif;

  function new(virtual uart_if vif);
    this.vif = vif;
    mbx = new();
    drv = new(mbx);
    sco = new(mbx);
    drv.vif = this.vif;
    sco.vif = this.vif;
  endfunction

  task pre_test();
    drv.drive_reset();
  endtask

  task test();
    $display("[ENV] Test started at %0t", $time);

      drv.run();
      sco.run();

    
    $display("[ENV] Test ended at %0t", $time);
  endtask

  task run();
    pre_test();
    test();
  endtask

endclass
