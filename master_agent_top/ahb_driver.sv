class ahb_driver extends uvm_driver#(ahb_trans);

   `uvm_component_utils(ahb_driver);

virtual bridge_if.AHB_DRV_MP vif;

ahb_config ahb_cfg;


function new(string name ="ahb_driver",uvm_component parent);
   super.new(name,parent);
endfunction:new


function void build_phase(uvm_phase phase);
     super.build_phase(phase);

if(!uvm_config_db#(ahb_config)::get(this,"","ahb_config",ahb_cfg))
	`uvm_fatal("FATAL_OCCURRED","data is not getting from top agent")

endfunction

function void connect_phase(uvm_phase phase);
     vif=ahb_cfg.vif;
     super.connect_phase(phase);
endfunction

task run_phase(uvm_phase phase);

// active low reset signal
  @(vif.AHB_DRV);
  vif.AHB_DRV.Hresetn<=0;
   @(vif.AHB_DRV);
    vif.AHB_DRV.Hresetn<=1;
//while(vif.AHB_DRV.HREADY_OUT!==1)
 // @(vif.AHB_DRV);

   


forever
	begin
	seq_item_port.get_next_item(req);
	send_to_dut(req);
	seq_item_port.item_done(req);
	end
endtask

task send_to_dut(ahb_trans xtn);
while(vif.AHB_DRV.Hreadyout===0)
@(vif.AHB_DRV);
$display("driving the Data");
vif.AHB_DRV.Haddr<=xtn.Haddr;
vif.AHB_DRV.Hwrite<=xtn.Hwrite;
vif.AHB_DRV.Htrans<=xtn.Htrans;
vif.AHB_DRV.Hsize<=xtn.Hsize;
vif.AHB_DRV.Hreadyin<=1;
vif.AHB_DRV.Hburst<=xtn.Hburst;

@(vif.AHB_DRV);
while(vif.AHB_DRV.Hreadyout===0)

@(vif.AHB_DRV);
if(xtn.Hwrite===1)
vif.AHB_DRV.Hwdata<=xtn.Hwdata;
else
vif.AHB_DRV.Hwdata<=16'hz;

// `uvm_info("AHB_DRIVER",$sformatf(req.sprint()),UVM_LOW)
endtask

endclass:ahb_driver
