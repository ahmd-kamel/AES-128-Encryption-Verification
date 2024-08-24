class aes_passive_agent extends uvm_agent;

  `uvm_component_utils(aes_passive_agent)
  aes_monitor    mon;

  function new(string name = "aes_passive_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon = aes_monitor :: type_id :: create("mon", this);
  endfunction
endclass 