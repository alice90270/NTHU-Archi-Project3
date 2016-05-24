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
wire [32-1:0] pc_i;
wire [32-1:0] pc_o;
wire [32-1:0] instruction;
wire [32-1:0] pc_add4;

/**** ID stage ****/
//control signal...
wire [32-1:0] instr;
wire [32-1:0] signed_imm_i;
wire [32-1:0] pc_sum;
wire [32-1:0] rs;
wire [32-1:0] rt;
wire [6-1:0] funct;
wire ID_reg_write;
wire ID_mem_reg;
wire ID_mem_read;
wire ID_mem_write;
wire ID_beq_ctrl;
wire [8-1:0]ID_alu_op;
wire ID_alu_src;
wire ID_reg_dst;


/**** EX stage ****/
//control signal...
wire EX_reg_write;
wire EX_mem_reg;
wire EX_mem_read;
wire EX_mem_write;
wire EX_beq_ctrl;
wire [8-1:0]alu_op;
wire reg_dst;
wire alu_src;
wire [32-1:0] current_pc;
wire [32-1:0] beq_sum;
wire [32-1:0] shift_o;
wire [32-1:0] shift_i;
wire [32-1:0] rs2;
wire [32-1:0] rt2;
wire [32-1:0] rt3;
wire [32-1:0] alu_i1;
wire [32-1:0] alu_i2;
wire zero;
wire [32-1:0] alu_o;
wire [4-1:0] alu_ctrl;
wire [5-1:0] target_rd;
wire [5-1:0] target_rt; 
wire [5-1:0] rt_or_rd;
wire [1:0] forwardA;
wire [1:0] forwardB;  
wire [5-1:0] forward_rs;
wire [5-1:0] forward_rt;


/**** MEM stage ****/
//control signal...
wire MEM_reg_write;
wire MEM_mem_reg;
wire mem_read;
wire mem_write;
wire [32-1:0] beq_addr;
wire beq_ctrl;
wire is_beq;
wire is0;
wire [5-1:0] destination;
wire [32-1:0] data_i1;
wire [32-1:0] data_i2;
wire [32-1:0] data_o;

wire testread;
wire testwrite;
/**** WB stage ****/
//control signal...
wire reg_write;
wire mem_reg;
wire [5-1:0] w_reg;
wire [32-1:0] mux_i1;
wire [32-1:0] mux_i2;
wire [32-1:0] pre2;


/**** Data hazard ****/
//control signal...

/*	op  	rs	  rt 	 rd 	shamt	 funct
	6		5	   5	  5  	  5	   	   6
		[25:21] [20:16] [15:11]
*/
/****************************************
*       Instantiate modules             *
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) mux_address(
	.data0_i(pc_add4),
	.data1_i(beq_addr),
	.select_i(is_beq),
	.data_o(pc_i)
);

ProgramCounter PC(
		.clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_i) ,   
	    .pc_out_o(pc_o) 
        );
	
Adder Add_pc(
        .src1_i(pc_o),     
	    .src2_i(32'd4),     
	    .sum_o(pc_add4)  
		);
		
Instr_Memory IM(
        .pc_addr_i(pc_o),  
	    .instr_o(instruction)    
	    );
		
Pipe_Reg #(.size(32)) IF_ID1( .rst_i(rst_i),	.clk_i(clk_i),   .data_i(pc_add4),	.data_o(pc_sum)	);
Pipe_Reg #(.size(32)) IF_ID2( .rst_i(rst_i),	.clk_i(clk_i),   .data_i(instruction),	.data_o(instr)	);

		
//Instantiate the components in ID stage
Reg_File RF(
        .clk_i(clk_i),
		.rst_i(rst_i),
		.RSaddr_i(instr[25:21]) ,
		.RTaddr_i(instr[20:16]) ,
		.RDaddr_i(w_reg) ,
		.RDdata_i(pre2),
		.RegWrite_i(reg_write),
		.RSdata_o(rs) ,
		.RTdata_o(rt)
		);

Decoder Control(
        .instr_op_i(instr[31:26]), 
	    .RegWrite_o(ID_reg_write), 
	    .ALU_op_o(ID_alu_op),   
	    .ALUSrc_o(ID_alu_src),   
	    .RegDst_o(ID_reg_dst),   
		.Branch_o(ID_beq_ctrl), 
		.MemWrite_o(ID_mem_write),
		.MemRead_o(ID_mem_read),
		.MemtoReg_o(ID_mem_reg)
		);

Sign_Extend Sign_Extend(
        .data_i(instr[15:0]),
        .data_o(signed_imm_i)
		);	

Pipe_Reg #(.size(1)) ID_EX1( 	.rst_i(rst_i),	.clk_i(clk_i),   .data_i(ID_reg_write),	.data_o(EX_reg_write)	);
Pipe_Reg #(.size(1)) ID_EX2(	 .rst_i(rst_i),	.clk_i(clk_i),   .data_i(ID_mem_reg),	.data_o(EX_mem_reg)		);
Pipe_Reg #(.size(1)) ID_EX3(	 .rst_i(rst_i),	.clk_i(clk_i),   .data_i(ID_mem_read),	.data_o(EX_mem_read)		);
Pipe_Reg #(.size(1)) ID_EX4(	 .rst_i(rst_i),	.clk_i(clk_i),   .data_i(ID_mem_write),	.data_o(EX_mem_write)		);
Pipe_Reg #(.size(1)) ID_EX5(	 .rst_i(rst_i),	.clk_i(clk_i),   .data_i(ID_beq_ctrl),	.data_o(EX_beq_ctrl)		);
Pipe_Reg #(.size(8)) ID_EX6(	 .rst_i(rst_i),	.clk_i(clk_i),   .data_i(ID_alu_op),	.data_o(alu_op)		);
Pipe_Reg #(.size(1)) ID_EX7(	 .rst_i(rst_i),	.clk_i(clk_i),   .data_i(ID_alu_src),	.data_o(alu_src)	);
Pipe_Reg #(.size(1)) ID_EX8(	 .rst_i(rst_i),	.clk_i(clk_i),   .data_i(ID_reg_dst),	.data_o(reg_dst)		);
Pipe_Reg #(.size(32)) ID_EX9(	 .rst_i(rst_i),	.clk_i(clk_i),   .data_i(pc_sum),	.data_o(current_pc)		);
Pipe_Reg #(.size(32)) ID_EX10(	 .rst_i(rst_i),	.clk_i(clk_i),   .data_i(rs),	.data_o(rs2)		);
Pipe_Reg #(.size(32)) ID_EX11(	 .rst_i(rst_i),	.clk_i(clk_i),   .data_i(rt),	.data_o(rt2)		);
Pipe_Reg #(.size(5)) ID_EX12(	 .rst_i(rst_i),	.clk_i(clk_i),   .data_i(instr[25:21]),	.data_o(forward_rs)		);
Pipe_Reg #(.size(5)) ID_EX13(	 .rst_i(rst_i),	.clk_i(clk_i),   .data_i(instr[20:16]),	.data_o(forward_rt)		);
Pipe_Reg #(.size(32)) ID_EX14(	 .rst_i(rst_i),	.clk_i(clk_i),   .data_i(signed_imm_i),	.data_o(shift_i)		);
Pipe_Reg #(.size(5)) ID_EX15(	 .rst_i(rst_i),	.clk_i(clk_i),   .data_i(instr[20:16]),	.data_o(target_rt)		);
Pipe_Reg #(.size(5)) ID_EX16(	 .rst_i(rst_i),	.clk_i(clk_i),   .data_i(instr[15:11]),	.data_o(target_rd)		);
Pipe_Reg #(.size(6)) ID_EX17(	 .rst_i(rst_i),	.clk_i(clk_i),   .data_i(instr[5:0]),	.data_o(funct)		);

		
//Instantiate the components in EX stage	   
ALU ALU(
        .src1_i(alu_i1),
	    .src2_i(alu_i2),
	    .ctrl_i(alu_ctrl),
	    .result_o(alu_o),
		.zero_o(zero)
		);
		
ALU_Ctrl ALU_Control(
        .funct_i(funct),   
        .ALUOp_i(alu_op),   
        .ALUCtrl_o(alu_ctrl) 
		);

MUX_3to1 #(.size(32)) Mux1(
		.data0_i(rs2),
		.data1_i(pre2),
		.data2_i(data_i1),
        .select_i(forwardA),
        .data_o(alu_i1)
        );
		
MUX_3to1 #(.size(32)) Mux2(
        .data0_i(rt2),
		.data1_i(pre2),
		.data2_i(data_i1),
        .select_i(forwardB),
        .data_o(rt3)
		);
MUX_2to1 #(.size(32)) Mux3(
		.data0_i(rt3),
		.data1_i(shift_i),
        .select_i(alu_src),
        .data_o(alu_i2)
        );
		
MUX_2to1 #(.size(5)) Mux4(
		.data0_i(target_rt),
		.data1_i(target_rd),
        .select_i(reg_dst),
        .data_o(rt_or_rd)
        );
Shift_Left_Two_32 SL2(
		.data_i(shift_i),
		.data_o(shift_o)
		);		
		
Adder Add_beq(
        .src1_i(current_pc),     
	    .src2_i(shift_o),     
	    .sum_o(beq_sum)  
		);
		
Pipe_Reg #(.size(1)) EX_MEM1(	.rst_i(rst_i),	.clk_i(clk_i),   .data_i(EX_reg_write),	.data_o(MEM_reg_write)	);
Pipe_Reg #(.size(1)) EX_MEM2(	.rst_i(rst_i),	.clk_i(clk_i),   .data_i(EX_mem_reg),	.data_o(MEM_mem_reg)	);
Pipe_Reg #(.size(1)) EX_MEM3(	.rst_i(rst_i),	.clk_i(clk_i),   .data_i(EX_mem_read),	.data_o(mem_read)	);
Pipe_Reg #(.size(1)) EX_MEM4(	.rst_i(rst_i),	.clk_i(clk_i),   .data_i(EX_mem_write),	.data_o(mem_write)	);
Pipe_Reg #(.size(1)) EX_MEM5(	.rst_i(rst_i),	.clk_i(clk_i),   .data_i(EX_beq_ctrl),	.data_o(beq_ctrl)	);
Pipe_Reg #(.size(32)) EX_MEM6(	.rst_i(rst_i),	.clk_i(clk_i),   .data_i(beq_sum),	.data_o(beq_addr)	);
Pipe_Reg #(.size(1)) EX_MEM7(	.rst_i(rst_i),	.clk_i(clk_i),   .data_i(zero),	.data_o(is0)	);
Pipe_Reg #(.size(32)) EX_MEM8(	.rst_i(rst_i),	.clk_i(clk_i),   .data_i(alu_o),	.data_o(data_i1)	);
Pipe_Reg #(.size(32)) EX_MEM9(	.rst_i(rst_i),	.clk_i(clk_i),   .data_i(rt3),	.data_o(data_i2)	);
Pipe_Reg #(.size(5)) EX_MEM10(	.rst_i(rst_i),	.clk_i(clk_i),   .data_i(rt_or_rd),	.data_o(destination)	);


//Pipe_Reg #(.size(1)) testR(	.rst_i(rst_i),	.clk_i(clk_i),   .data_i(testread),	.data_o(mem_read)	);
//Pipe_Reg #(.size(1)) testW(	.rst_i(rst_i),	.clk_i(clk_i),   .data_i(testwrite),	.data_o(mem_write)	);
			   
//Instantiate the components in MEM stage
assign is_beq = beq_ctrl & is0;

Data_Memory DM(
     .clk_i(clk_i),
     .addr_i(data_i1),
     .data_i(data_i2),
     .MemRead_i(mem_read), 
     .MemWrite_i(mem_write),
     .data_o(data_o)
	    );

Pipe_Reg #(.size(1)) MEM_WB1( .rst_i(rst_i),	.clk_i(clk_i),   .data_i(MEM_reg_write),	.data_o(reg_write)	);
Pipe_Reg #(.size(1)) MEM_WB3( .rst_i(rst_i),	.clk_i(clk_i),   .data_i(MEM_mem_reg),	.data_o(mem_reg)	);
Pipe_Reg #(.size(32)) MEM_WB4( .rst_i(rst_i),	.clk_i(clk_i),   .data_i(data_o),	.data_o(mux_i1)	);
Pipe_Reg #(.size(32)) MEM_WB5( .rst_i(rst_i),	.clk_i(clk_i),   .data_i(data_i1),	.data_o(mux_i2)	);
Pipe_Reg #(.size(5)) MEM_WB6( .rst_i(rst_i),	.clk_i(clk_i),   .data_i(destination),	.data_o(w_reg)	);

//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux_mem(
		.data0_i(mux_i2),
		.data1_i(mux_i1),
        .select_i(mem_reg),
        .data_o(pre2)
        );
ForwardinUnit FU(
		.EX_MEMRegWrite(MEM_reg_write),//1
		.MEM_WBRegWrite(reg_write),//1
		.EX_MEMRegisterRd(destination),//5
		.MEM_WBRegisterRd(w_reg),//5
		.ID_EXRegisterRs(forward_rs),//5
		.ID_EXRegisterRt(forward_rt),//5
		.ForwardA(forwardA),//2
		.ForwardB(forwardB)//2
		);		


/****************************************
*         Signal assignment             *
****************************************/
	/*	
always @(posedge clk_i) begin

//$monitor("instr=%b",instr);
//$monitor("instruction=%b",instruction);
//$monitor("rs=%d",rs);
//$monitor("rt=%d",rt);
//$monitor("forward_rt=%b",forward_rt);
//$monitor("forward_rs=%b",forward_rs);
	$display("alu_i2=%d",alu_i2);
if(mem_read==1)
	$display("***mem_read=%d***",mem_read);
if(mem_write==1)
	$display("***mem_write=%d**",mem_write);
//$display("W_reg=%d",w_reg);
$display("address=%d",data_i1);
$display("value=%d",data_i2);
$display("data_o=%d",data_o);
//$display("pre2=%d",pre2);
//$display("mux1=%d",mux_i1);
//$display("mux2=%d",mux_i2);



end		
*/

endmodule

