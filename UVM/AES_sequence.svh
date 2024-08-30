class aes_sequence extends uvm_sequence#(aes_sequence_item);

    `uvm_object_utils(aes_sequence)

    function new(string name = "aes_sequence");
        super.new(name);
    endfunction
endclass

class reset_sequence extends aes_sequence;

    `uvm_object_utils(reset_sequence)
    aes_sequence_item tnx;

    function new(string name = "reset_sequence");
        super.new(name);
    endfunction

    task gen_txn();
        tnx = aes_sequence_item :: type_id :: create("tnx");
        start_item(tnx);
        assert (tnx.randomize() with {reset_n == 0;})
            else $error("Ranomization failed!");
        finish_item(tnx);
    endtask

    task body();
        gen_txn();
    endtask
endclass

class random_sequence extends aes_sequence;

    `uvm_object_utils(random_sequence)
    aes_sequence_item tnx;
    integer num_tnxs = 1000;

    function new(string name = "random_sequence");
        super.new(name);
    endfunction

    task gen_txn();
        tnx = aes_sequence_item :: type_id :: create("tnx");
        start_item(tnx);
        assert (tnx.randomize() with {reset_n == 1; valid_in == 1;})
            else $error("Ranomization failed!");
        finish_item(tnx);
    endtask

    task body();
        repeat(num_tnxs)
            gen_txn();
    endtask
endclass