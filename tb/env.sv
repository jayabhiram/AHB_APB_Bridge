class env extends uvm_env;

  `uvm_component_utils(env)

apb_agent_top apb_agt_toph;
ahb_agent_top ahb_agt_toph;
scoreboard scoreboard_h;
virtual_sequencer vseqrh;

function new(string name ="env",uvm_component parent);
   super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
   super.build_phase(phase);

apb_agt_toph=apb_agent_top::type_id::create("apb_agt_toph",this);
ahb_agt_toph=ahb_agent_top::type_id::create("ahb_agt_toph",this);
scoreboard_h=scoreboard::type_id::create("scoreboard_h",this);
vseqrh=virtual_sequencer::type_id::create("vseqrh",this);

endfunction:build_phase

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);

vseqrh.ahb_seqrh[0]=ahb_agt_toph.ahb_agnth.ahb_seqrh;

vseqrh.apb_seqrh[0]=apb_agt_toph.apb_agnth.apb_seqrh;



ahb_agt_toph.ahb_agnth.ahb_monh.ahb_port.connect(scoreboard_h.ahb_fifo.analysis_export);

apb_agt_toph.apb_agnth.apb_monh.apb_port.connect(scoreboard_h.apb_fifo.analysis_export);
endfunction


endclass:env
