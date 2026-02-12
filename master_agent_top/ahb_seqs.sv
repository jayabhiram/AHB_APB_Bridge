class base_seqs extends uvm_sequence#(ahb_trans);

  `uvm_object_utils(base_seqs)

  bit [31:0] haddr;
  bit hwrite;
  bit [2:0] hsize;
  bit [2:0] hburst;
  bit [9:0] length;
  bit [31:0] hwdata;
  int start_addr,boundary_addr;


function new(string name ="base_seqs");
 super.new(name);
endfunction


endclass:base_seqs


//-------------single transfer--------------------------//

class single_seqs extends base_seqs;

      `uvm_object_utils(single_seqs)

function new(string name ="single_seqs");
 super.new(name);
endfunction

task body();
req=ahb_trans::type_id::create("req");

repeat(5)
begin
	start_item(req);
	assert(req.randomize() with { Htrans == 2'b10; Hburst == 3'b0; Hwrite ==1'b1;});
	finish_item(req);
end
endtask

endclass:single_seqs

//------------------unspecified_length------------------------\\

class unspef_len_seqs extends base_seqs;

     `uvm_object_utils(unspef_len_seqs)

function new(string name ="unspef_len_seqs");
 super.new(name);
endfunction

task body();
this.set_response_queue_depth(-1);
req=ahb_trans::type_id::create("req");

repeat(5)
begin
	start_item(req);
	assert(req.randomize() with { Htrans == 2'b10; Hburst == 3'b001;});
	finish_item(req);
	length=req.length;
	hwrite=req.Hwrite;
	haddr=req.Haddr;
	hsize=req.Hsize;
	hburst=req.Hburst;
	hwdata=req.Hwdata;


//-----------sequential transfer----------------//

  for(int i=0;i<length;i++)
	begin
	start_item(req);
	assert(req.randomize() with { Htrans == 2'b11; Hburst == hburst; Hsize==hsize; Hwrite==hwrite; Haddr == haddr+(2**Hsize);});
	finish_item(req);

	haddr=req.Haddr;
	
end
end
endtask

endclass:unspef_len_seqs
//-------------------------increment trans --------------------------------\\


class incr_seqs extends base_seqs;

     `uvm_object_utils(incr_seqs)

function new(string name ="incr_seqs");
 super.new(name);
endfunction

task body();
this.set_response_queue_depth(-1);
req=ahb_trans::type_id::create("req");

repeat(5)
begin
	start_item(req);
	assert(req.randomize() with { Htrans == 2'b10; Hburst inside{3,5,7};});
	finish_item(req);
	length=req.length;
	hwrite=req.Hwrite;
	haddr=req.Haddr;
	hsize=req.Hsize;
	hburst=req.Hburst;
	hwdata=req.Hwdata;


//-----------sequential transfer----------------//

  for(int i=0;i<length;i++)
	begin
	start_item(req);
	assert(req.randomize() with { Htrans == 2'b11; Hburst == hburst; Hsize==hsize; Hwrite==hwrite; Haddr == haddr+(2**Hsize);});
	finish_item(req);

	haddr=req.Haddr;
	
end
end
endtask

endclass:incr_seqs




//-------------------------------wraps seqs -----------------------

class wrap_seqs extends base_seqs;

	`uvm_object_utils(wrap_seqs)



function new(string name ="wrap_seqs");
 super.new(name);
endfunction

task body();
this.set_response_queue_depth(-1);
req=ahb_trans::type_id::create("req");

repeat(5)
begin
	start_item(req);
	assert(req.randomize() with { Htrans == 2'b10; Hburst inside {2,4,6};});
	finish_item(req);
	length=req.length;
	hwrite=req.Hwrite;
	haddr=req.Haddr;
	hsize=req.Hsize;
	hburst=req.Hburst;
	hwdata=req.Hwdata;

start_addr=int'((haddr/((2**hsize)*length))*((2**hsize)*length));

boundary_addr=start_addr+((2**hsize)*length);

//haddr=(req.Haddr+(2**hsize));



  for(int i=0;i<length;i++)
	begin
	if(haddr==boundary_addr)
		haddr=start_addr;

	start_item(req);
	assert(req.randomize() with { Htrans == 2'b11; Hburst == hburst; Hsize==hsize; Hwrite==hwrite; Haddr == haddr+(2**Hsize);});
	finish_item(req);

	haddr=(req.Haddr+(2**hsize));
	
end
end
endtask

endclass:wrap_seqs



















