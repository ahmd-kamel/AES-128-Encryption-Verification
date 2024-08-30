`include "AES_Encrypt.v"

module AES_128 #(parameter DATA_W = 128, KEY_L = 128)
(
  intf inst
  /*
  input  wire clk,                         //system clock
  input  wire reset_n,                     //asynch reset
  input  wire valid_in,                    //cipherkey valid signal
  input  wire [KEY_L-1:0]  cipher_key,     //cipher key
  input  wire [DATA_W-1:0] plain_text,     //plain text
  output reg  [DATA_W-1:0] cipher_text,    //cipher text
  output reg  valid_out                   //output valid signal*/

);
  
  wire [DATA_W-1:0] cipher_text_comb;
  AES_Encrypt AES_128_inst(inst.plain_text, inst.cipher_key, cipher_text_comb);
  
  
  always@(posedge inst.clk or negedge inst.reset_n) begin 
    if(!inst.reset_n) begin
      inst.cipher_text <= 'b0;
      inst.valid_out   <= 1'b0;
    end 
    else if(inst.valid_in) begin
      inst.cipher_text <= cipher_text_comb;
      inst.valid_out   <= 1'b1;
    end 
    else begin
      inst.valid_out   <= 1'b0;
    end
  end
  
endmodule