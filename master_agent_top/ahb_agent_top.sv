class ahb_agent_top extends uvm_env;

 `uvm_component_utils(ahb_agent_top)

ahb_agent ahb_agnth;
env_config env_cfg;
ahb_config ahb_cfg;

function new(string name ="ahb_agent_top",uvm_component parent);
   super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);

ahb_agnth=ahb_agent::type_id::create("ahb_agnth",this);

if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
  `uvm_fatal("FATAL OCCURRED","data is not getting from database")

ahb_cfg=env_cfg.ahb_cfg;

uvm_config_db#(ahb_config)::set(this,"*","ahb_config",ahb_cfg);
   super.build_phase(phase);
endfunction:build_phase

endclass:ahb_agent_top

