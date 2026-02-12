class apb_agent_top extends uvm_env;

 `uvm_component_utils(apb_agent_top)

apb_agent apb_agnth;
env_config env_cfg;
apb_config apb_cfg;

function new(string name ="apb_agent_top",uvm_component parent);
   super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);

apb_agnth=apb_agent::type_id::create("apb_agnth",this);
if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
  `uvm_fatal("FATAL OCCURRED","data is not getting from database")

apb_cfg=env_cfg.apb_cfg;

uvm_config_db#(apb_config)::set(this,"*","apb_config",apb_cfg);
   super.build_phase(phase);
endfunction:build_phase

endclass:apb_agent_top

