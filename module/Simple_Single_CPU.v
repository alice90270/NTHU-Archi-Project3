`timescale 1ns / 1ps
//Subject:     Architecture project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: Structure for R-type
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
    clk_i,
	rst_i
);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signals
wire [32-1:0] mux_dataMem_result_w;
wire ctrl_register_write_w;
wire [32-1:0] add4;
wire [32-1:0] pc_o;
wire [32-1:0] pc_i;
wire [32-1:0] adder_o;
wire [32-1:0] instruction;
wire [32-1:0] adder1_o;
wire [32-1:0] adder2_o;
wire reg_dst;
wire [5-1:0]w_reg;
wire [32-1:0] rs_o;
wire [32-1:0] rt_o;
wire [8-1:0] alu_op;
wire alu_src;
wire branch;
wire [4-1:0]alu_ctrl;
wire [32-1:0] signed_instr;
wire [32-1:0]alu_i;
wire is_beq;
wire [32-1:0] shift2;
wire mem_read;
wire mem_write;
wire mem_reg;
wire [32-1:0] alu_o;
wire [32-1:0] mem_o;

assign add4 = 32'd4;
//Create components
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_i) ,   
	    .pc_out_o(pc_o) 
	    );
	
Adder Adder1(
        .src1_i(pc_o),     
	    .src2_i(add4),     
	    .sum_o(adder1_o)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_o),  
	    .instr_o(instruction)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instruction[20:16]),
        .data1_i(instruction[15:11]),
        .select_i(reg_dst),
        .data_o(w_reg)
        );	

//DO NOT MODIFY	.RDdata_i && .RegWrite_i
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
	
//DO NOT MODIFY	.RegWrite_o
Decoder Decoder(
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

ALU_Ctrl AC(
        .funct_i(instruction[5:0]),   
        .ALUOp_i(alu_op),   
        .ALUCtrl_o(alu_ctrl) 
        );
	
Sign_Extend SE(
        .data_i(instruction[15:0]),
        .data_o(signed_instr)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(rt_o),
        .data1_i(signed_instr),
        .select_i(alu_src),
        .data_o(alu_i)
        );	
		
ALU ALU(
        .src1_i(rs_o),
	    .src2_i(alu_i),
	    .ctrl_i(alu_ctrl),
	    .result_o(alu_o),
		.zero_o(is_beq)
	    );
		
Adder Adder2(
        .src1_i(adder1_o),     
	    .src2_i(shift2),     
	    .sum_o(adder2_o)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(signed_instr),
        .data_o(shift2)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(adder1_o),
        .data1_i(adder2_o),
        .select_i(branch&&is_beq),
        .data_o(pc_i)
        );	
		
Data_Memory DataMemory
 (
     .clk_i(clk_i),
     .addr_i(alu_o),
     .data_i(rt_o),
     .MemRead_i(mem_read), 
     .MemWrite_i(mem_write),
     .data_o(mem_o)
 );

//DO NOT MODIFY	.data_o
 MUX_2to1 #(.size(32)) Mux_DataMem_Read(
         .data0_i(alu_o),
         .data1_i(mem_o),
         .select_i(mem_reg),
         .data_o(mux_dataMem_result_w)
 );

endmodule