class aes_agent extends uvm_agent;

    `uvm_component_utils(aes_agent)

    function new(string name = "aes_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass 