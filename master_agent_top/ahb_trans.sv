class ahb_trans extends uvm_sequence_item;

  `uvm_object_utils(ahb_trans)

bit Hclk;//clock

bit Hresetn;//reset

rand bit Hwrite;//transfer direction read or write

rand bit [2:0] Hsize; //transfer size 1 byte or 2 byte or 4 byte and here we are sending upto 32 bits

rand bit [1:0] Htrans; //transfer type non seq or seq or idle or busy

rand bit [31:0] Haddr;// address

rand bit [2:0] Hburst;//single trans or back to back or increment trans or wrap trans

rand bit [31:0] Hwdata;//write data bus

bit [31:0] Hrdata; // output and coming from slave

bit Hreadyin=1;

bit Hreadyout;

bit [1:0]Hresp;

rand bit [4:0] length;//unspecified length

constraint valid_size {Hsize inside{[0:2]};}

//constraint Hsize_count {Hsize dist{3'b000:=3,3'b001:=3,3'b010:=3};}

//constraint valid_length{(2**Hsize)*length <=1024;} //length should not cross 1kb

constraint valid_haddr{Hsize==1 ->Haddr%2==0;
                       Hsize==2 ->Haddr%4==0;} //address should be always even

constraint valid_haddr1{Haddr inside {[32'h8000_0000 : 32'h8000_03ff],
                                      [32'h8400_0000 : 32'h8400_03ff],
                                      [32'h8800_0000 : 32'h8800_03ff],
                                      [32'h8c00_0000 : 32'h8c00_03ff]};}//4 slave address

constraint c4{if(Hburst==0)length==1;
	      if(Hburst==2||Hburst==3)length==4;
	      if(Hburst==4||Hburst==5)length==8;
              if(Hburst==6||Hburst==7)length==16; length!=0;}

constraint c5{((Haddr%1024)+((2**Hsize)*length))<=1024;}//unspecified burst

constraint c6{Hwrite dist{1:=80,0:=20};}


function new(string name = "ahb_trans");
      super.new(name);
endfunction:new


function void do_print(uvm_printer printer);
   super.do_print(printer);

printer.print_field("Haddr",this.Haddr,32,UVM_HEX);
printer.print_field("Hwdata",this.Hwdata,32,UVM_HEX);
printer.print_field("Hwrite",this.Hwrite,1,UVM_DEC);
printer.print_field("Htrans",this.Htrans,2,UVM_DEC);
printer.print_field("Hsize",this.Hsize,2,UVM_DEC);
printer.print_field("Hburst",this.Hburst,3,UVM_HEX);
printer.print_field("Hrdata",this.Hrdata,32,UVM_HEX);



endfunction:do_print


endclass:ahb_trans
