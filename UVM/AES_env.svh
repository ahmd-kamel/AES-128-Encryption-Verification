class aes_env extends uvm_env;

    `uvm_component_utils(aes_env)

    virtual intf vif;
    aes_agent  		  agnt;
    aes_scoreboard    scoreboard;
    aes_subscriber    subscriber;

    function new(string name = "aes_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agnt = aes_agent :: type_id :: create("agnt", this);
        scoreboard = aes_scoreboard :: type_id :: create("scoreboard", this);
        subscriber = aes_subscriber :: type_id :: create("subscriber", this);
	if(!uvm_config_db#(virtual intf) :: get(this, "", "env_if", vif))
		`uvm_fatal(get_full_name(), "Error!")
	uvm_config_db#(virtual intf) :: set(this, "agnt", "agnt_if", vif);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agnt.agnt_ap.connect(scoreboard.input_ap);
        agnt.agnt_ap.connect(subscriber.input_aexp);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask


endclass