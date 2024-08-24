class aes_monitor extends uvm_monitor;

    `uvm_component_utils(aes_monitor)

    function new(string name = "aes_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass 