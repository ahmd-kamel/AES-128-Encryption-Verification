class aes_sequence_item extends uvm_sequence_item;
  parameter DATA_W = 128, KEY_L = 128;
  `uvm_object_utils(aes_sequence_item)

  function new(string name = "aes_sequence_item");
    super.new(name);
  endfunction

  rand bit  reset_n;          
  rand bit  valid_in;                
  rand bit  [DATA_W-1:0] plain_text; 
  rand bit  [KEY_L-1:0]  cipher_key;
  logic  [DATA_W-1:0] cipher_text;
  logic  valid_out;

  constraint reset_behaviour 
  {
    if (reset_n == 0)
    {
      valid_in == 0;
    }
  }

    constraint valid_data_in 
    {
      valid_in dist {0:=5, 1:=95};
    }

      task display_item(string class_name);
    $display("%0s :%0t inputs: reset_n =%0b valid_in=%0b plain_text=%0h", class_name, $time, reset_n, valid_in, plain_text);
    endtask

endclass
