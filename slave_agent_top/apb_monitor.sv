class apb_monitor extends uvm_monitor;

   `uvm_component_utils(apb_monitor);

virtual bridge_if.APB_MON_MP vif;

uvm_analysis_port#(apb_trans) apb_port;

apb_config apb_cfg;
apb_trans apb_xtnh;

function new(string name ="apb_monitor",uvm_component parent);
   super.new(name,parent);
endfunction:new



function void build_phase(uvm_phase phase);
     super.build_phase(phase);

if(!uvm_config_db#(apb_config)::get(this,"","apb_config",apb_cfg))
	`uvm_fatal("FATAL_OCCURRED","data is not getting from top agent")
   apb_port=new("apb_port",this);
endfunction

function void connect_phase(uvm_phase phase);
     vif=apb_cfg.vif;
     super.connect_phase(phase);
endfunction


task run_phase(uvm_phase phase);
forever
collect_data();
endtask
//..... task for collect data
task collect_data();
	#20;
	apb_xtnh =apb_trans::type_id::create("apb_xtnh");
//	while(vif.APB_MON.Pselx===0)
//	@(vif.APB_MON);

	while(vif.APB_MON.Penable===0)
	@(vif.APB_MON);

	
	
	apb_xtnh.Pwrite= vif.APB_MON.Pwrite;


	apb_xtnh.Paddr = vif.APB_MON.Paddr;
	apb_xtnh.Pselx = vif.APB_MON.Pselx;
	apb_xtnh.Penable = vif.APB_MON.Penable;
	//@(vif.APB_MON);

	if(vif.APB_MON.Pwrite=== 1'b1)
		apb_xtnh.Pwdata = vif.APB_MON.Pwdata;
	else 
		apb_xtnh.Prdata= vif.APB_MON.Prdata;

//	apb_xtnh.print();
		repeat(1)
	@(vif.APB_MON);

	apb_port.write(apb_xtnh);
	//`uvm_info(get_type_name(),$sformatf("this is apb monitor \n %s",apb_xtnh.sprint()),UVM_LOW)
		


endtask


endclass:apb_monitor
