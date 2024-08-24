class aes_subscriber extends uvm_subscriber#(aes_sequence_item);

  `uvm_component_utils(aes_subscriber)
  aes_sequence_item aes_item;

  function new(string name = "aes_subscriber", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void write(aes_sequence_item t);
  endfunction
endclass