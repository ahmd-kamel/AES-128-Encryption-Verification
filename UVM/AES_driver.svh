class aes_driver extends uvm_driver #(aes_sequence_item);

    `uvm_component_utils(aes_driver)
    virtual intf vif;
    aes_sequence_item item;

    function new(string name = "aes_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction 

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item = aes_sequence_item :: type_id :: create("item");
	if(!uvm_config_db#(virtual intf) :: get(this, "", "drv_if", vif))
		`uvm_fatal(get_full_name(), "Error!")
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(item);
            @(vif.cb);
            vif.reset_n    <= item.reset_n;
            vif.valid_in   <= item.valid_in;
            vif.cipher_key <= item.cipher_key;
            vif.plain_text <= item.plain_text;
            seq_item_port.item_done();
        end
    endtask
endclass
