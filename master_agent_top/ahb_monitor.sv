class ahb_monitor extends uvm_monitor;

   `uvm_component_utils(ahb_monitor);

uvm_analysis_port#(ahb_trans) ahb_port;

virtual bridge_if.AHB_MON_MP vif;

ahb_config ahb_cfg;

ahb_trans xtn;


function new(string name ="ahb_monitor",uvm_component parent);
   super.new(name,parent);
endfunction:new


function void build_phase(uvm_phase phase);
     super.build_phase(phase);

if(!uvm_config_db#(ahb_config)::get(this,"","ahb_config",ahb_cfg))
	`uvm_fatal("FATAL_OCCURRED","data is not getting from top agent")
  ahb_port=new("ahb_port",this); 
endfunction

function void connect_phase(uvm_phase phase);
     vif=ahb_cfg.vif;
     super.connect_phase(phase);
endfunction


task run_phase(uvm_phase phase);
forever
	begin
	  collect_data();
	end
endtask

task collect_data();

xtn=ahb_trans::type_id::create("xtn");

while(vif.AHB_MON.Hreadyout===0)

@(vif.AHB_MON);

while(vif.AHB_MON.Htrans!==2'b10&&vif.AHB_MON.Htrans!==2'b11)

@(vif.AHB_MON);

xtn.Haddr=vif.AHB_MON.Haddr;
xtn.Hwrite=vif.AHB_MON.Hwrite;
xtn.Htrans=vif.AHB_MON.Htrans;
xtn.Hsize=vif.AHB_MON.Hsize;
xtn.Hburst=vif.AHB_MON.Hburst;


@(vif.AHB_MON);

if(xtn.Hwrite==1)
	xtn.Hwdata=vif.AHB_MON.Hwdata;
else
	xtn.Hrdata=vif.AHB_MON.Hrdata;

ahb_port.write(xtn);
 //`uvm_info("AHB_DRIVER",$sformatf(xtn.sprint()),UVM_LOW)
endtask

endclass:ahb_monitor
