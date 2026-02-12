class ahb2apb_vbase_seq extends uvm_sequence #(uvm_sequence_item);

	`uvm_object_utils(ahb2apb_vbase_seq)

	ahb_sequencer ahb_seqrh[];
	apb_sequencer apb_seqrh[];

	virtual_sequencer vsqrh;

	env_config m_cfg;

	extern function new(string name = "ahb2apb_vbase_seq");
	extern task body();

endclass

//constructor 
function ahb2apb_vbase_seq::new(string name = "ahb2apb_vbase_seq");
	super.new(name);
endfunction

//run phase
task ahb2apb_vbase_seq::body();
	if(!uvm_config_db #(env_config)::get(null, get_full_name(),"env_config", m_cfg))
		`uvm_fatal("get_type_name()", "cannot get cfg")
	ahb_seqrh = new[m_cfg.no_of_ahb_agents];
	apb_seqrh = new[m_cfg.no_of_apb_agents];

	assert($cast(vsqrh, m_sequencer))
	else
		begin
			`uvm_error("BODY", "error in $cast")
		end
		foreach(ahb_seqrh[i])
		ahb_seqrh[i]= vsqrh.ahb_seqrh[i];
		foreach(apb_seqrh[i])
		apb_seqrh[i]= vsqrh.apb_seqrh[i];
endtask

//single transfer
class single_vseq extends ahb2apb_vbase_seq;

	`uvm_object_utils(single_vseq)

	single_seqs ss;

	extern function new(string name = "single_vseq");
	extern task body();

endclass

//constructor
function single_vseq::new(string name = "single_vseq");
	super.new(name);
endfunction

//body
task single_vseq::body();
	super.body();
	if(m_cfg.has_ahb_agent)
		begin
			ss = single_seqs::type_id::create("ss");
			ss.start(ahb_seqrh[0]);
		end
endtask

//burst transfer
class burst_vseq extends ahb2apb_vbase_seq;

	`uvm_object_utils(burst_vseq)

	unspef_len_seqs bs;

	extern function new(string name = "burst_vseq");
	extern task body();

endclass

//constructor
function burst_vseq::new(string name = "burst_vseq");
	super.new(name);
endfunction

//body
task burst_vseq::body();
	super.body();
	if(m_cfg.has_ahb_agent)
		begin
			bs = unspef_len_seqs::type_id::create("bs");
			bs.start(ahb_seqrh[0]);
		end
endtask

//incr transfer
class incr_vseq extends ahb2apb_vbase_seq;

	`uvm_object_utils(incr_vseq)

	incr_seqs is;

	extern function new(string name = "incr_vseq");
	extern task body();

endclass

//constructor
function incr_vseq::new(string name = "incr_vseq");
	super.new(name);
endfunction

//body
task incr_vseq::body();
	super.body();
	if(m_cfg.has_ahb_agent)
		begin
			is = incr_seqs::type_id::create("is");
			is.start(ahb_seqrh[0]);
		end
endtask

//single transfer
class wrap_vseq extends ahb2apb_vbase_seq;

	`uvm_object_utils(wrap_vseq)

	wrap_seqs ws;

	extern function new(string name = "wrap_vseq");
	extern task body();

endclass

//constructor
function wrap_vseq::new(string name = "wrap_vseq");
	super.new(name);
endfunction

//body
task wrap_vseq::body();
	super.body();
	if(m_cfg.has_ahb_agent)
		begin
			ws = wrap_seqs::type_id::create("ws");
			ws.start(ahb_seqrh[0]);
		end
endtask

