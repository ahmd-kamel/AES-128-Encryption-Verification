class aes_test extends uvm_test;

    `uvm_component_utils(aes_test)
    
    function new(string name = "aes_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction 
endclass