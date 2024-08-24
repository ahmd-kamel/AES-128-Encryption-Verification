class aes_sequence_item extends uvm_sequence_item;

    `uvm_object_utils(aes_sequence_item)

    function new(string name = "aes_sequence_item");
        super.new(name);
    endfunction
endclass