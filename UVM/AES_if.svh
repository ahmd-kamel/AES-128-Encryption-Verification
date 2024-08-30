interface intf(input logic clk);
  parameter DATA_W = 128;
  parameter KEY_L = 128;
  
  logic  reset_n;          
  logic  valid_in;                
  logic  [KEY_L-1:0]  cipher_key;
  logic  [DATA_W-1:0] plain_text; 
  logic  [DATA_W-1:0] cipher_text;
  logic  valid_out;
  
  clocking cb @(posedge clk);
    default input #1step output #1step;
    input  valid_in;
    input  cipher_key;
    input  plain_text;
    input  reset_n;
    output cipher_text;
    output valid_out;
  endclocking
endinterface