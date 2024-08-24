class aes_driver extends uvm_driver #(aes_sequence_item);

    `uvm_component_utils(aes_driver)
    
    function new(string name = "aes_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction 
endclass