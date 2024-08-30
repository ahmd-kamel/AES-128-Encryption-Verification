class aes_agent extends uvm_agent;

  `uvm_component_utils(aes_agent)

  virtual intf       vif;
  aes_driver         drv;
  aes_sequencer      seqr;
  aes_monitor    	 mon;
  uvm_analysis_port#(aes_sequence_item) agnt_ap;

  function new(string name = "aes_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv  = aes_driver    :: type_id :: create("drv", this);
    seqr = aes_sequencer :: type_id :: create("seqr", this);
    mon  = aes_monitor   :: type_id :: create("mon", this);
    agnt_ap = new("agnt_ap", this);
	if(!uvm_config_db#(virtual intf) :: get(this, "", "agnt_if", vif))
		`uvm_fatal(get_full_name(), "Error!")
	uvm_config_db#(virtual intf) :: set(this, "drv", "drv_if", vif);
	uvm_config_db#(virtual intf) :: set(this, "mon", "mon_if", vif);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
    mon.mon_ap.connect(this.agnt_ap);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask
endclass