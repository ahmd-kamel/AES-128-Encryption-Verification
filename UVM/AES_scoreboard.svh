class aes_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(aes_scoreboard)

    function new(string name = "aes_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass