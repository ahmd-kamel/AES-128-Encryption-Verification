class aes_monitor extends uvm_monitor;

  `uvm_component_utils(aes_monitor)
  virtual intf vif;
  aes_sequence_item item;
  uvm_analysis_port #(aes_sequence_item) mon_ap;

  function new(string name = "aes_monitor", uvm_component parent = null);
    super.new(name, parent);
    mon_ap = new("mon_ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item = aes_sequence_item :: type_id :: create("item");
    if(!uvm_config_db#(virtual intf) :: get(this, "", "mon_if", vif))
      `uvm_fatal(get_full_name(), "Error!")
      endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    #10;
    forever begin
      @(vif.cb);
      item.reset_n     = vif.reset_n;
      item.valid_in    = vif.valid_in;
      item.cipher_key  = vif.cipher_key;
      item.plain_text  = vif.plain_text;
      item.cipher_text = vif.cipher_text;
      item.valid_out   = vif.valid_out;
      mon_ap.write(item);
    end
  endtask
endclass