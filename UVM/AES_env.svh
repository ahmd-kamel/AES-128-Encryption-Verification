class aes_env extends uvm_env;

    `uvm_component_utils(aes_env)

    function new(string name = "aes_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass