`include "AES_if.svh"
`include "AES_package.sv"

module top;
  import uvm_pkg::*;
  import aes_pkg::*;
  
  parameter N = 128;
  logic [N-1:0] in;
  logic [N-1:0] key;
  logic [N-1:0] out;

  bit clk;
  always #5 clk = ~clk;
  
  intf in1(clk);

  AES_Encrypt enc_inst(in, key, out);

  initial begin
    uvm_config_db#(virtual intf) :: set(null, "uvm_test_top", "intfc", in1);
    run_test("aes_test");
  end
endmodule