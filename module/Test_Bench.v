//`timescale 1ns / 1ps
//Subject:     Architecture Final Project - Test Bench
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

`define CYCLE_TIME 20			
`define END_COUNT 100
module TestBench;

//Internal Signals
reg         CLK;
reg         RST;
integer     count;

integer     f,i;
//Create tested modle  
Pipe_CPU cpu(
        .clk_i(CLK),
		.rst_i(RST)
		);
 
//Main function

always #(`CYCLE_TIME/2) CLK = ~CLK;	

initial  begin
	
	CLK = 1;
    RST = 0;
	count = 0;

	$readmemb("testcase_0.txt", cpu.IM.Instr_Mem);
    #(`CYCLE_TIME/2)      RST = 1;
    #(`CYCLE_TIME*`END_COUNT)	$finish;
end

always@(posedge CLK) begin
    count = count + 1;
	if( count == `END_COUNT ) begin
		for(i=0; i<32; i=i+1) begin
			//$display("$%0d: %0d", i, cpu.RF.Reg_File[i]);
      $display("$%0d: 0x%08x", i, cpu.RF.Reg_File[i]);
		end
	end
end
  
endmodule
