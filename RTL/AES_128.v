module AES_128 #(parameter DATA_W = 128, KEY_L = 128)
(
  input  clk,                         //system clock
  input  reset_n,                     //asynch reset
  input  valid_in,                    //cipherkey valid signal
  input  [KEY_L-1:0]  cipher_key,     //cipher key
  input  [DATA_W-1:0] plain_text,     //plain text
  output [DATA_W-1:0] cipher_text,    //cipher text
  output valid_out                    //output valid signal

);
  
endmodule