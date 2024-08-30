`include "AES_if.svh"
`include "AES_128.v"

module top;
  import uvm_pkg::*;
  import aes_pkg::*;

  bit clk;
  always #5 clk = ~clk;
  
  intf in1(clk);

  AES_128 enc_inst(
    .inst(in1)
    /*
    .clk(in1.clk),
    .reset_n(in1.reset_n),
    .valid_in(in1.valid_in),
    .cipher_key(in1.cipher_key),
    .plain_text(in1.plain_text),
    .cipher_text(in1.cipher_text),
    .valid_out(in1.valid_out)*/
  );

  initial begin
    uvm_config_db#(virtual intf) :: set(null, "uvm_test_top", "intfc", in1);
    run_test("aes_test");
    $dumpvars;
    $dumpfile("dump.vcd");
  end
  
endmodule