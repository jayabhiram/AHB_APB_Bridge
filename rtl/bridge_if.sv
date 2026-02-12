`include "definitions.v"


interface  bridge_if(input bit clock);


           logic  Hresetn;
           logic[1:0] Htrans;
	   logic[2:0]Hsize;
	   logic Hreadyin;
           logic[2:0] Hburst;
	   logic[`WIDTH-1:0] Hwdata; 
	   logic[`WIDTH-1:0] Haddr;
	   logic Hwrite;
           logic[`WIDTH-1:0] Prdata;
	   logic[`WIDTH-1:0] Hrdata;
	   logic[1:0] Hresp;
	   logic Hreadyout;
	   logic[`SLAVES-1:0] Pselx;
	   logic Pwrite;
	   logic Penable; 
	   logic[`WIDTH-1:0] Paddr;
	   logic[`WIDTH-1:0] Pwdata;


clocking AHB_DRV@(posedge clock);

default input #1 output #1;
input Hreadyout;
output Hburst;
output Hresetn,Hwrite,Hreadyin;
output Hsize;
output Htrans;
output Hwdata,Haddr;

endclocking

clocking AHB_MON@(posedge clock);

default input #1 output #1;

input Hreadyout;
input Hwdata,Haddr,Hrdata;
input Hwrite,Htrans,Hreadyin;
input Hburst,Hsize;
input Hresp;

endclocking 

 

clocking  APB_DRV@(posedge clock);

default input #1 output #1;

input Pselx;
input Pwrite,Penable;
input Pwdata,Paddr;
output Prdata;

endclocking

clocking APB_MON@(posedge clock);

default input #1 output #1;

input Prdata,Pwdata,Pwrite,Penable,Pselx,Paddr;

endclocking

modport AHB_DRV_MP(clocking AHB_DRV);

modport AHB_MON_MP(clocking AHB_MON);

modport APB_DRV_MP(clocking APB_DRV);

modport APB_MON_MP(clocking APB_MON);


endinterface
