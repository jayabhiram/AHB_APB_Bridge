class scoreboard extends uvm_scoreboard;

   `uvm_component_utils(scoreboard)


uvm_tlm_analysis_fifo #(ahb_trans) ahb_fifo;
uvm_tlm_analysis_fifo #(apb_trans) apb_fifo;


ahb_trans ahb_xtnh;
apb_trans apb_xtnh;

ahb_trans ahb_cov_data;
apb_trans apb_cov_data;


	covergroup ahb_cg;
		option.per_instance = 1;

		HTRANSS   : coverpoint ahb_cov_data.Htrans {bins htrans[] = {[2:3]};}

		HsizeE    : coverpoint ahb_cov_data.Hsize  {bins hsize[] = {[0:2]};}

		HBURSTT   : coverpoint ahb_cov_data.Hburst {bins hburst[] = {[0:7]};}

		HaddrR    : coverpoint ahb_cov_data.Haddr  {bins first_slave  = {[32'h8000_0000 : 32'h8000_03ff]};
						           bins second_slave = {[32'h8400_0000 : 32'h8400_03ff]};
							   bins third_slave  = {[32'h8800_0000 : 32'h8800_03ff]};
							   bins fourth_slave = {[32'h8c00_0000 : 32'h8c00_03ff]};}
													
		HwriteE   : coverpoint ahb_cov_data.Hwrite;
			
	//	DATA_IN  : coverpoint ahb_cov_data.Hwdata

	//	DATA_OUT :

		
	endgroup



//=================================================================FUNCTIONAL COVERAGE APB SIDE==============================================================//

	covergroup apb_cg;
	
		option.per_instance=1;

		PaddrR    : coverpoint apb_cov_data.Paddr  {bins first_slave  = {[32'h8000_0000 : 32'h8000_03ff]};
						           bins second_slave = {[32'h8400_0000 : 32'h8400_03ff]};
							   bins third_slave  = {[32'h8800_0000 : 32'h8800_03ff]};
							   bins fourth_slave = {[32'h8c00_0000 : 32'h8c00_03ff]};}
																
		PWRITEE   : coverpoint apb_cov_data.Pwrite;

		PSELL     : coverpoint apb_cov_data.Pselx   {bins first_slave   = {4'b0001};
							   bins second_slave  = {4'b0010};
							   bins third_slave   = {4'b0100};
							   bins fourth_slave  = {4'b1000};}

	
	endgroup
		
	
function new(string name="scoreboard",uvm_component parent);
	super.new(name,parent);
	ahb_fifo=new("ahb_fifo",this);
	apb_fifo=new("apb_fifo",this);
	ahb_cg=new();
	apb_cg=new();
endfunction

	


//=================================================================FUNCTIONAL COVERAGE AHB SIDE==============================================================//



	task run_phase(uvm_phase phase);
		forever 
			begin
				fork

					begin
			//	$display("==========================================before==========================================================");
						
						ahb_fifo.get(ahb_xtnh);	
//	$display("======================================================after==============================================");

						`uvm_info("SCOREBOARD AHB",$sformatf("src_xtn data getting from tlm fifo \n %s", ahb_xtnh.sprint()),UVM_LOW)
						ahb_cov_data = ahb_xtnh;
						ahb_cg.sample();
					end

					begin
						
						apb_fifo.get(apb_xtnh);

						`uvm_info("SCOREBOARD APB",$sformatf("apb_xtn data getting from tlm fifo \n %s", apb_xtnh.sprint()),UVM_LOW)
						apb_cov_data = apb_xtnh;
						apb_cg.sample();
					end


				join
					check_data(ahb_xtnh, apb_xtnh);

			end
	endtask





//=====================================================CHECK DATA TASK========================================================================//
	task check_data(ahb_trans ahb_xtnh, apb_trans apb_xtnh);
		
		if(ahb_xtnh.Hwrite)
			begin
				case(ahb_xtnh.Hsize)
				
				2'b00 : begin
						 if(ahb_xtnh.Haddr[1:0] == 2'b00)
							compare_ahb_data(ahb_xtnh.Hwdata[7:0], apb_xtnh.Pwdata, ahb_xtnh.Haddr, apb_xtnh.Paddr);
					
						 else if(ahb_xtnh.Haddr[1:0] == 2'b01)
							compare_ahb_data(ahb_xtnh.Hwdata[15:8], apb_xtnh.Pwdata, ahb_xtnh.Haddr, apb_xtnh.Paddr);
						
						 else if(ahb_xtnh.Haddr[1:0] == 2'b10)
							compare_ahb_data(ahb_xtnh.Hwdata[23:16], apb_xtnh.Pwdata, ahb_xtnh.Haddr, apb_xtnh.Paddr);
	
						 else
							compare_ahb_data(ahb_xtnh.Hwdata[31:24], apb_xtnh.Pwdata, ahb_xtnh.Haddr, apb_xtnh.Paddr);

					end
			
				2'b01: begin
						if(ahb_xtnh.Haddr[1:0] == 2'b00)
							compare_ahb_data(ahb_xtnh.Hwdata[15:0], apb_xtnh.Pwdata, ahb_xtnh.Haddr, apb_xtnh.Paddr);
						else
							compare_ahb_data(ahb_xtnh.Hwdata[31:16], apb_xtnh.Pwdata, ahb_xtnh.Haddr, apb_xtnh.Paddr);
					
					end


				2'b10 : begin
						compare_ahb_data(ahb_xtnh.Hwdata, apb_xtnh.Pwdata, ahb_xtnh.Haddr, apb_xtnh.Paddr);
					end
				
				endcase

			end

		else
			begin
				case(ahb_xtnh.Hsize)
				
				2'b00 : begin
						 if(ahb_xtnh.Haddr[1:0] == 2'b00)
							compare_apb_data(ahb_xtnh.Hrdata[7:0], apb_xtnh.Prdata[7:0], ahb_xtnh.Haddr, apb_xtnh.Paddr);
					
						 else if(ahb_xtnh.Haddr[1:0] == 2'b01)
							compare_apb_data(ahb_xtnh.Hrdata[15:8], apb_xtnh.Prdata[15:8], ahb_xtnh.Haddr, apb_xtnh.Paddr);
						
						 else if(ahb_xtnh.Haddr[1:0] == 2'b10)
							compare_apb_data(ahb_xtnh.Hrdata[23:16], apb_xtnh.Prdata[23:16], ahb_xtnh.Haddr, apb_xtnh.Paddr);
	
						 else
							compare_apb_data(ahb_xtnh.Hrdata[31:24], apb_xtnh.Prdata[31:24], ahb_xtnh.Haddr, apb_xtnh.Paddr);

					end
			
				2'b01: begin
						if(ahb_xtnh.Haddr[1:0] == 2'b00)
							compare_apb_data(ahb_xtnh.Hrdata[15:0], apb_xtnh.Prdata[15:0], ahb_xtnh.Haddr, apb_xtnh.Paddr);
						else
							compare_apb_data(ahb_xtnh.Hrdata[31:16], apb_xtnh.Prdata[31:16], ahb_xtnh.Haddr, apb_xtnh.Paddr);
					
					end


				2'b10 : begin
						compare_apb_data(ahb_xtnh.Hrdata, apb_xtnh.Prdata, ahb_xtnh.Haddr, apb_xtnh.Paddr);
					end
				
				endcase

			end
	
	endtask



//======================================================COMPARE AHB DATA TASK============================================================================//
	task compare_ahb_data(int unsigned Hwdata, Pwdata, Haddr, Paddr);
	//src_xtn h;
//	if(h.Hwrite==1)
		begin
			if(Haddr==Paddr) begin
				$display("ADDRESS COMPARED SUCESSFULLY");
				$display("Haddr = %0d, Paddr = %0d",Haddr, Paddr);
			
			end

			else
				begin	
				$display("ADDRESS MISMATCHED");
				$display("Haddr = %0d, Paddr = %0d",Haddr, Paddr);
		
				end
	
			if(Hwdata==Pwdata) begin
				$display("DATA COMPARED SUCESSFULLY");
				$display("Hwdata = %0d, Pwdata = %0d",Hwdata, Pwdata);
		
			end

			else
			begin	
				$display("DATA MISMATCH");
				$display("Hwdata = %0d, Pwdata = %0d",Hwdata, Pwdata);
			end
		end
	endtask




//======================================================COMPARE APB DATA TASK============================================================================//

	task compare_apb_data(int unsigned Hrdata, Prdata, Haddr, Paddr);
//	src_xtn t;
//	if(t.Hwrite==0)

		begin
			if(Haddr==Paddr) begin
				$display("ADDRESS COMPARED SUCESSFULLY");
				$display("Haddr = %0d, Paddr = %0d",Haddr, Paddr);
			
			end

			else
				begin	
				$display("ADDRESS MISMATCHED");
				$display("Haddr = %0d, Paddr = %0d",Haddr, Paddr);
		
				end
	
			if(Hrdata==Prdata) begin
				$display("DATA COMPARED SUCESSFULLY");
				$display("Hrdata = %0d, Prdata = %0d",Hrdata, Prdata);
		
			end

			else
			begin	
				$display("DATA MISMATCHD");
				$display("Hrdata = %0d, Prdata = %0d",Hrdata, Prdata);
			end
		end

		
	endtask

		




endclass:scoreboard

