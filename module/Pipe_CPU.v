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
PC PC(

        );

Instr_Memory IM(

	    );
			
Adder Add_pc(

		);

		
Pipe_Reg #(.size()) IF_ID(       

		);
		
//Instantiate the components in ID stage
Reg_File RF(

		);

Decoder Control(

		);

Sign_Extend Sign_Extend(

		);	

Pipe_Reg #(.size()) ID_EX(

		);
		
//Instantiate the components in EX stage	   
ALU ALU(

		);
		
ALU_Control ALU_Control(

		);

MUX_2to1 #(.size()) Mux1(

        );
		
MUX_2to1 #(.size()) Mux2(

        );

Pipe_Reg #(.size()) EX_MEM(

		);
			   
//Instantiate the components in MEM stage
Data_Memory DM(

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

