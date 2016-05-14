`timescale 1ns / 1ps
/*******************************************************************
 * Create Date: 	2016/05/03
 * Design Name: 	Pipeline CPU
 * Module Name:		Pipe_Reg 
 * Project Name: 	Architecture Project_3 Pipeline CPU
 
 * Please DO NOT change the module name, or your'll get ZERO point.
 ******************************************************************/
module Pipe_Reg(
            rst_i,
			clk_i,   
			data_i,
			data_o
);
					
parameter size = 0;
input                  rst_i;
input                  clk_i;		  
input      [size-1: 0] data_i;
output reg [size-1: 0] data_o;
	  
always @(posedge clk_i or negedge  rst_i) begin
	if( rst_i == 0) data_o <= 0;
    else data_o <= data_i;
end

endmodule	