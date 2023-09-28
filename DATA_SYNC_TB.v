`timescale 1ns/1ps
module DATA_SYNC_TB ();



/////////////////////////////////////////////////////////
///////////////////// Parameters ////////////////////////
/////////////////////////////////////////////////////////

parameter CLK_PERIOD 	= 100 ; 
parameter BUS_WIDTH_TB  = 8 ; 
parameter NUM_STAGES_TB = 3 ; 


/////////////////////////////////////////////////////////
//////////////////// DUT Signals ////////////////////////
/////////////////////////////////////////////////////////

reg 	[BUS_WIDTH_TB-1:0] unsync_bus_TB;
reg 	bus_enable_TB;
reg 	CLK_TB;
reg 	RST_TB;
wire 	enable_pulse_TB;
wire 	[BUS_WIDTH_TB-1:0] sync_bus_TB;




initial
  begin
  initialize() ;
  reset ();
  unsync_bus_TB =  'd6 ;
  #50;
	bus_enable_TB = 1'b1;
	
	#(3*CLK_PERIOD);
	#0.0005;
	  if (unsync_bus_TB == sync_bus_TB) /////////////////// 2 stages means 2 flipflop means latency 2 clock cycles
		$display ("test case succeeded");
	  else
		$display ("test case failed");
  #5000;
  $stop;
  
  
  
  end


/////////////// Signals Initialization //////////////////

task initialize ;
  begin
	bus_enable_TB = 1'b0;
	unsync_bus_TB =  'b0 ;
	CLK_TB    	  = 1'b0  ;
	RST_TB    	  = 1'b1  ;    
  end
endtask

///////////////////////// RESET /////////////////////////

task reset ;
 begin
  #(CLK_PERIOD)
  RST_TB  = 'b0;           // rst is activated
  #(CLK_PERIOD)
  RST_TB  = 'b1;
  #(CLK_PERIOD) ;
 end
endtask


///////////////////// Clock Generator //////////////////

always #(CLK_PERIOD/2.0) CLK_TB = ~CLK_TB ;




// Design Instaniation
DATA_SYNC #(.BUS_WIDTH(BUS_WIDTH_TB), .NUM_STAGES(NUM_STAGES_TB)) DUT 
(
.unsync_bus		(unsync_bus_TB),
.CLK			(CLK_TB),           
.RST			(RST_TB),           
.bus_enable		(bus_enable_TB),  
.enable_pulse	(enable_pulse_TB),
.sync_bus	  	(sync_bus_TB)
);


endmodule 	