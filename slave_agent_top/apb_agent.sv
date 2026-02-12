class apb_agent extends uvm_agent;

 `uvm_component_utils(apb_agent)

apb_driver  apb_drvh;
apb_sequencer apb_seqrh;
apb_monitor apb_monh;
apb_config apb_cfg;

function new(string name ="apb_agent",uvm_component parent);
   super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
   super.build_phase(phase);

apb_monh=apb_monitor::type_id::create("apb_monh",this);

if(!uvm_config_db#(apb_config)::get(this,"","apb_config",apb_cfg))
  `uvm_fatal("FATAL OCCURRED","data is not getting from database")

if(apb_cfg.is_active==UVM_ACTIVE)
  
apb_seqrh=apb_sequencer::type_id::create("apb_seqrh",this);
apb_drvh=apb_driver::type_id::create("apb_drvh",this);

endfunction:build_phase

function void connect_phase(uvm_phase phase);
 
if(apb_cfg.is_active==UVM_ACTIVE)
  apb_drvh.seq_item_port.connect(apb_seqrh.seq_item_export);

  super.connect_phase(phase);

endfunction:connect_phase

endclass:apb_agent

