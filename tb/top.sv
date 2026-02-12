module top;

import uvm_pkg::*;

import bridge_pkg::*;

bit clock;

always
#5 clock=~clock;

bridge_if  in0(clock);

rtl_top DUT(.Hclk(clock),
            .Hresetn(in0.Hresetn),
	    .Htrans(in0.Htrans),
	    .Hsize(in0.Hsize), 
	    .Hreadyin(in0.Hreadyin),
	    .Hwdata(in0.Hwdata), 
	    .Haddr(in0.Haddr),
 	    .Hwrite(in0.Hwrite),
            .Prdata(in0.Prdata),
	    .Hrdata(in0.Hrdata),
	    .Hresp(in0.Hresp),
            .Hreadyout(in0.Hreadyout),
	    .Pselx(in0.Pselx),
	    .Pwrite(in0.Pwrite),
            .Penable(in0.Penable), 
	    .Paddr(in0.Paddr),
	    .Pwdata(in0.Pwdata));



initial
       begin
	    `ifdef VCS
	    $fsdbDumpvars(0,top);
	    `endif
            uvm_config_db#(virtual bridge_if)::set(null,"*","in0",in0);
            run_test();
       end
       
endmodule   
           


