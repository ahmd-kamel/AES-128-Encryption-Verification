class aes_test extends uvm_test;

    `uvm_component_utils(aes_test)
    virtual intf vif_tst;
    aes_env env;
    random_sequence sequence_inst;
    reset_sequence sequence_rst;

    function new(string name = "aes_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction 

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = aes_env :: type_id :: create("env", this);
        sequence_inst = random_sequence :: type_id :: create("sequence_inst");
        sequence_rst = reset_sequence :: type_id :: create("sequence_rst");
	if(!uvm_config_db#(virtual intf) :: get(this, "", "intfc", vif_tst))
		`uvm_fatal(get_full_name(), "Error")
	uvm_config_db#(virtual intf) :: set(this, "env", "env_if", vif_tst);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        sequence_rst.start(env.agnt.seqr);
        sequence_inst.start(env.agnt.seqr);
        phase.drop_objection(this);
    endtask
endclass