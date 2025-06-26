program testbench(uart_if vif);

//Section 4.1 : Include test cases
`include "env.sv"
  environment env;

//Section 4.2 : Define test class handles
//Section 6: Verification Flow
initial begin
$display("[Program Block] Simulation Started at time=%0t",$time);
//Section 6.1 : Construct test object and pass required interface handles
  env=new(vif);

//Section 6.2 : Start the testcase.
env.run();
$display("[Program Block] Simulation Finished at time=%0t",$time);
end

endprogram


`include "top.sv"
