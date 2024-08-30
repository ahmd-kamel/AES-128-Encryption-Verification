class aes_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(aes_scoreboard)

  uvm_analysis_imp#(aes_sequence_item, aes_scoreboard) input_ap;
  int total_no_tnxs;
  int total_valid_in;
  int total_invalid_in;
  int total_reset_tnxs;
  int no_valid_correct;
  int no_valid_incorrect;

  string line;
  int file;
  bit [127:0] exp_out;
  
  function new(string name = "aes_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    input_ap = new("input_ap", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask

  function void write(input aes_sequence_item item);
      if (!item.reset_n) begin
        $display("[SCB-RESET]");
        total_reset_tnxs++;
      end 
    else if (item.valid_in) begin
      total_valid_in++;
      
      file = $fopen("data_key.txt", "w");
      if (file == 0) begin
          $display("Error: Unable to open data_key.txt");
          $finish;
      end
      $fwrite(file, "%h\n", item.plain_text);
      $fwrite(file, "%h\n", item.cipher_key);
      $fclose(file);
      $system("python3 reference_model.py");
      
      
      file = $fopen("output.txt", "r");
      if (file == 0) begin
          $display("Error: Unable to open output.txt");
          $finish;
      end
      if (!$fgets(line, file)) begin
          $display("Error: Unable to read from output.txt");
          $fclose(file);
          $finish;
      end
      $sscanf(line, "%h", exp_out);
      $fclose(file);
      
      if((exp_out == item.cipher_text) && (item.valid_out == 1'b1)) begin
        $display("[SCB-PASS] Expected = %0h Actual = %0h Text = %0h Key = %0h Valid = %0d", exp_out, item.cipher_text, item.plain_text, item.cipher_key, item.valid_out);
        no_valid_correct++;
      end
      else begin
        $display("[SCB-FAIL] Expected = %0h Actual = %0h Text = %0h Key = %0h Valid = %0d", exp_out, item.cipher_text, item.plain_text, item.cipher_key, item.valid_out);
        no_valid_incorrect++;
      end
    end 
    else begin
        total_invalid_in++;
      end
      total_no_tnxs++;
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), $sformatf("total no of tnx is %0d", total_no_tnxs), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("total no of reset tnx is %0d", total_reset_tnxs), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("total no of valid tnx is %0d", total_valid_in), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("total no of valid correct tnx is %0d", no_valid_correct), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("total no of valid incorrect tnx is %0d", no_valid_incorrect), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("total no of in valid in tnx is %0d", total_invalid_in), UVM_LOW)
  endfunction

endclass