class aes_subscriber extends uvm_subscriber#(aes_sequence_item);

  `uvm_component_utils(aes_subscriber)
  aes_sequence_item item;
  uvm_analysis_imp#(aes_sequence_item, aes_subscriber) input_aexp;
  real cov;

  covergroup aes_cov;
    reset: coverpoint item.reset_n
    {
      bins low = {0};
      bins high = {1};
      bins hi_lw = (1=>0);
      bins lw_hi = (0=>1);
    }
    valid_input: coverpoint item.valid_in
    {
      bins low = {0};
      bins high = {1};
      bins hi_lw = (1=>0);
      bins lw_hi = (0=>1);
    }
    input_text: coverpoint item.plain_text
    {
      option.auto_bin_max = 1000;
    }

    input_key: coverpoint item.cipher_key
    {
      option.auto_bin_max = 1000;
    }

    output_text: coverpoint item.cipher_text
    {
      option.auto_bin_max = 1000;
    }

    valid_output: coverpoint item.valid_out
    {
      bins low = {0};
      bins high = {1};
      bins hi_lw = (1=>0);
      bins lw_hi = (0=>1);
    }


  endgroup

  function new(string name = "aes_subscriber", uvm_component parent = null);
    super.new(name, parent);
    aes_cov = new();
  endfunction

  virtual function void write(aes_sequence_item t);
    item = t;
    aes_cov.sample();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item = aes_sequence_item :: type_id :: create("item");
    input_aexp = new("input_aexp", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    cov = aes_cov.get_coverage();
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Coverage is %f", cov), UVM_LOW)
  endfunction
endclass

