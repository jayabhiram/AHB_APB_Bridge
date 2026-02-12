class ahb_config extends uvm_object;

  `uvm_object_utils(ahb_config)

virtual bridge_if vif;
uvm_active_passive_enum is_active;


function new(string name ="ahb_config");
  super.new(name);
endfunction

endclass:ahb_config

