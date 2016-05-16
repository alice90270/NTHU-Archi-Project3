`timescale 1ns / 1ps
/*******************************************************************
 * Create Date: 	2016/05/03
 * Design Name: 	Pipeline CPU
 * Module Name:		Pipe_CPU 
 * Project Name: 	Architecture Project_3 Pipeline CPU
 
 * Please DO NOT change the module name, or your'll get ZERO point.
 * You should add your code here to complete the project 3.
 ******************************************************************/
module Pipe_CPU(
        clk_i,
		rst_i
		);
    
/****************************************
*            I/O ports                  *
****************************************/
input clk_i;
input rst_i;

/****************************************
*          Internal signal              *
****************************************/

/**** IF stage ****/
//control signal...


/**** ID stage ****/
//control signal...


/**** EX stage ****/
//control signal...


/**** MEM stage ****/
//control signal...


/**** WB stage ****/
//control signal...


/**** Data hazard ****/
//control signal...


/****************************************
*       Instantiate modules             *
****************************************/
//Instantiate the components in IF stage
ProgramCounter PC(
		.clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_i) ,   
	    .pc_out_o(pc_o) 
        );

Instr_Memory IM(
        .pc_addr_i(pc_o),  
	    .instr_o(IFID_i)    
	    );
			
Adder Add_pc(
        .src1_i(pc_o),     
	    .src2_i(add4),     
	    .sum_o(adder1_o)  
		);

		
Pipe_Reg #(.size()) IF_ID(       
		.rst_i(rst_i),
		.clk_i(clk_i),   
		.data_i(IFID_i),
		.data_o(instruction)
		);
		
//Instantiate the components in ID stage
Reg_File RF(
        .clk_i(clk_i),
		.rst_i(rst_i),
		.RSaddr_i(instruction[25:21]) ,
		.RTaddr_i(instruction[20:16]) ,
		.RDaddr_i(w_reg) ,
		.RDdata_i(mux_dataMem_result_w[31:0]),
		.RegWrite_i(ctrl_register_write_w),
		.RSdata_o(rs_o) ,
		.RTdata_o(rt_o)
		);

Decoder Control(
        .instr_op_i(instruction[31:26]), 
	    .RegWrite_o(ctrl_register_write_w), 
	    .ALU_op_o(alu_op),   
	    .ALUSrc_o(alu_src),   
	    .RegDst_o(reg_dst),   
		.Branch_o(branch),   
		.MemWrite_o(mem_write),
		.MemRead_o(mem_read),
		.MemtoReg_o(mem_reg)
		);

Sign_Extend Sign_Extend(
        .data_i(instruction[15:0]),
        .data_o(signed_instr)
		);	

Pipe_Reg #(.size()) ID_EX(

		);
		
//Instantiate the components in EX stage	   
ALU ALU(
        .src1_i(rs_o),
	    .src2_i(alu_i),
	    .ctrl_i(alu_ctrl),
	    .result_o(alu_o),
		.zero_o(is_beq)
		);
		
ALU_Control ALU_Control(
        .funct_i(instruction[5:0]),   
        .ALUOp_i(alu_op),   
        .ALUCtrl_o(alu_ctrl) 
		);

MUX_2to1 #(.size(32)) Mux1(
        );
		
MUX_2to1 #(.size(32)) Mux2(
        );

Pipe_Reg #(.size()) EX_MEM(

		);
			   
//Instantiate the components in MEM stage
Data_Memory DM(
     .clk_i(clk_i),
     .addr_i(alu_o),
     .data_i(rt_o),
     .MemRead_i(mem_read), 
     .MemWrite_i(mem_write),
     .data_o(mem_o)
	    );

Pipe_Reg #(.size()) MEM_WB(
        
		);

//Instantiate the components in WB stage
MUX_3to1 #(.size()) Mux3(

        );

/****************************************
*         Signal assignment             *
****************************************/
	
endmodule

