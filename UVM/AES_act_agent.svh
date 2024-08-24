class aes_active_agent extends uvm_agent;

  `uvm_component_utils(aes_active_agent)

  aes_driver     drv;
  aes_sequencer  seqr;
  aes_monitor    mon;

  function new(string name = "aes_active_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv  = aes_driver    :: type_id :: create("drv", this);
    seqr = aes_sequencer :: type_id :: create("seqr", this);
    mon  = aes_monitor   :: type_id :: create("mon", this);
  endfunction
endclass 