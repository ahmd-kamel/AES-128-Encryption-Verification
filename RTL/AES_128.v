`include "AES_Encrypt.v"

module AES_128 #(parameter DATA_W = 128, KEY_L = 128)
(
  input  wire clk,                         //system clock
  input  wire reset_n,                     //asynch reset
  input  wire valid_in,                    //cipherkey valid signal
  input  wire [KEY_L-1:0]  cipher_key,     //cipher key
  input  wire [DATA_W-1:0] plain_text,     //plain text
  output reg  [DATA_W-1:0] cipher_text,    //cipher text
  output reg  valid_out                    //output valid signal

);
  
  reg  [KEY_L-1:0]  cipher_key_reg;
  reg  [DATA_W-1:0] plain_text_reg;
  reg  valid_in_reg;
  wire [DATA_W-1:0] cipher_text_comb;

  always@(posedge clk or negedge reset_n) begin 
    if(!reset_n) begin
      cipher_key_reg  <= 'b0;
      plain_text_reg  <= 'b0;
      valid_in_reg    <= 1'b0;
    end 
    else if(valid_in) begin
      cipher_key_reg  <= cipher_key;
      plain_text_reg  <= plain_text;
      valid_in_reg    <= 1'b1;
    end 
    else begin
      valid_in_reg = 1'b0;
    end
  end
  
  
  AES_Encrypt AES_128_inst(plain_text_reg, cipher_key_reg, cipher_text_comb);
  
  
  always@(posedge clk or negedge reset_n) begin 
    if(!reset_n) begin
      cipher_text <= 'b0;
      valid_out   <= 1'b0;
    end 
    else if(valid_in) begin
      cipher_text <= cipher_text_comb;
      valid_out   <= 1'b1;
    end 
    else begin
      valid_out   <= 1'b0;
    end
  end
  
endmodule