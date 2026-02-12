class apb_driver extends uvm_driver#(apb_trans);

   `uvm_component_utils(apb_driver);


virtual bridge_if.APB_DRV_MP vif;

apb_config apb_cfg;

apb_trans xtn;

function new(string name ="apb_driver",uvm_component parent);
   super.new(name,parent);
endfunction:new


function void build_phase(uvm_phase phase);
     super.build_phase(phase);

if(!uvm_config_db#(apb_config)::get(this,"","apb_config",apb_cfg))
	`uvm_fatal("FATAL_OCCURRED","data is not getting from top agent")

endfunction

function void connect_phase(uvm_phase phase);
     vif=apb_cfg.vif;
     super.connect_phase(phase);
endfunction

task run_phase(uvm_phase phase);
req=apb_trans::type_id::create("apb_req");
forever
begin 

send_to_dut(req);

end
endtask


task send_to_dut(apb_trans xtn);
		
//$display("2222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222");
		wait(vif.APB_DRV.Pselx!==0)// sel is = 0stay in the loop when it 1 one going to pwrite
			//@(vif.APB_DRV);
//$display("1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111");
		//while(vif.APB_DRV.Penable===0)
		//	@(vif.APB_DRV);

//$display("333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333");
		if(vif.APB_DRV.Pwrite==0)
		vif.APB_DRV.Prdata<={$random};
        
		repeat(2)
		@(vif.APB_DRV);

//$display("..................................PRDATA...........................................");
//`uvm_info("apb_driver",$sformatf(xtn.sprint()),UVM_LOW)

endtask



endclass:apb_driver
