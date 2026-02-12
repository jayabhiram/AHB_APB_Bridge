class base_test extends uvm_test;

  `uvm_component_utils(base_test)
int no_of_ahb_agents=1;
int no_of_apb_agents=1;
  env_config env_cfg;
  ahb_config ahb_cfg;
  apb_config apb_cfg;
  env env_h;
function new(string name ="base_test",uvm_component parent);
   super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   env_cfg=env_config::type_id::create("env_cfg");
   ahb_cfg=ahb_config::type_id::create("ahb_cfg");
   if(!uvm_config_db#(virtual bridge_if)::get(this,"","in0",ahb_cfg.vif))
     `uvm_fatal("FATAL_OCCURRED","interface is not get() from database")
   ahb_cfg.is_active=UVM_ACTIVE;
   env_cfg.ahb_cfg=ahb_cfg;


   apb_cfg=apb_config::type_id::create("apb_cfg");
   if(!uvm_config_db#(virtual bridge_if)::get(this,"","in0",apb_cfg.vif))
     `uvm_fatal("FATAL_OCCURRED","interface is not get() from database")
   apb_cfg.is_active=UVM_ACTIVE;
   env_cfg.apb_cfg=apb_cfg;


env_cfg.no_of_ahb_agents=no_of_ahb_agents;
env_cfg.no_of_apb_agents=no_of_apb_agents;


 uvm_config_db#(env_config)::set(this,"*","env_config",env_cfg);

env_h=env::type_id::create("env_h",this);

endfunction:build_phase


function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology;
  super.end_of_elaboration_phase(phase);

endfunction:end_of_elaboration_phase



endclass:base_test

class single_test extends base_test;
 
	`uvm_component_utils(single_test)

single_vseq single_h;

function new(string name ="single_test",uvm_component parent);
   super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
single_h=single_vseq::type_id::create("single_h");
endfunction


task run_phase(uvm_phase phase);

	phase.raise_objection(this);
//	single_h.start(env_h.ahb_agt_toph.ahb_agnth.ahb_seqrh);
        single_h.start(env_h.vseqrh);
	#100;
	phase.drop_objection(this);
endtask

endclass:single_test

class unspec_test extends base_test;
 
	`uvm_component_utils(unspec_test)

burst_vseq unspec_h;

function new(string name ="unspec_test",uvm_component parent);
   super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
//unspec_h=unspef_len_seqs::type_id::create("unspec_h");
unspec_h=burst_vseq::type_id::create("unspec_h");
endfunction


task run_phase(uvm_phase phase);

	phase.raise_objection(this);
//	unspec_h.start(env_h.ahb_agt_toph.ahb_agnth.ahb_seqrh);
	unspec_h.start(env_h.vseqrh);
	#100;
	phase.drop_objection(this);
endtask

endclass:unspec_test

class incr_test extends base_test;
 
	`uvm_component_utils(incr_test)

incr_vseq incr_h;

function new(string name ="incr_test",uvm_component parent);
   super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
//incr_h=incr_seqs::type_id::create("incr_h");
incr_h=incr_vseq::type_id::create("incr_h");

endfunction


task run_phase(uvm_phase phase);

	phase.raise_objection(this);
//	incr_h.start(env_h.ahb_agt_toph.ahb_agnth.ahb_seqrh);
	incr_h.start(env_h.vseqrh);
#100;
	phase.drop_objection(this);
endtask

endclass:incr_test

class wrap_test extends base_test;
 
	`uvm_component_utils(wrap_test)

wrap_vseq wrap_h;

function new(string name ="wrap_test",uvm_component parent);
   super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
//wrap_h=wrap_seqs::type_id::create("wrap_h");
wrap_h=wrap_vseq::type_id::create("wrap_h");

endfunction


task run_phase(uvm_phase phase);

	phase.raise_objection(this);
	//wrap_h.start(env_h.ahb_agt_toph.ahb_agnth.ahb_seqrh);
	wrap_h.start(env_h.vseqrh);
	#100;
	phase.drop_objection(this);
endtask

endclass:wrap_test



