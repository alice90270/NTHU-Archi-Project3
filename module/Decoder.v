//Subject:     Architecture project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	MemWrite_o,
	MemRead_o,
	MemtoReg_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [8-1:0] ALU_op_o; 
output         ALUSrc_o; 
output         RegDst_o; 
output         Branch_o; 
output			MemWrite_o;
output			MemRead_o;
output			MemtoReg_o; 

//Internal Signals
reg    [8-1:0] ALU_op_o;
reg            ALUSrc_o;//lw|sw|addi|stli
reg            RegWrite_o;//R|lw|addi|stli
reg            RegDst_o;//R
reg            Branch_o;//beq
reg			MemWrite_o;//sw
reg			MemRead_o;//lw
reg			MemtoReg_o; //lw
//Parameter


//Main function
always@(instr_op_i)begin
	case(instr_op_i)
		6'h00: begin
			ALU_op_o <= 8'h00; //R
			Branch_o<=0;
			ALUSrc_o <= 0;
			RegWrite_o<=1;
			RegDst_o<=1;
			MemWrite_o<=0;
			MemRead_o<=0;
			MemtoReg_o<=0;
//$display("R type");
		end
		6'h08: begin
			ALU_op_o <= 8'h08; //ADDI
			Branch_o<=0;
			ALUSrc_o <= 1;
			RegWrite_o<=1;
			RegDst_o<=0;
			MemWrite_o<=0;
			MemRead_o<=0;
			MemtoReg_o<=0;
//$display("ADDI");
		end
		6'h23: begin
			ALU_op_o <= 8'h23; //LW
			Branch_o<=0;
			ALUSrc_o <= 1;
			RegWrite_o<=1;
			RegDst_o<=0;
			MemWrite_o<=0;
			MemRead_o<=1;
			MemtoReg_o<=1;
//$display("LW");
		end
		6'h2B: begin
			ALU_op_o <= 8'h2B; //SW
			Branch_o<=0;
			ALUSrc_o <= 1;
			RegWrite_o<=0;
			RegDst_o<=0;
			MemWrite_o<=1;
			MemRead_o<=0;
			MemtoReg_o<=0;
//$display("SW");
		end
		6'h0A: begin
			ALU_op_o <= 8'h0A; //SLTI
			Branch_o<=0;
			ALUSrc_o <= 1;
			RegWrite_o<=1;
			RegDst_o<=0;
			MemWrite_o<=0;
			MemRead_o<=0;
			MemtoReg_o<=0;
//$display("SLTI");
		end
		6'h04: begin
			ALU_op_o <= 8'h04; //BEQ
			Branch_o<=1;
			ALUSrc_o <= 0;
			RegWrite_o<=0;
			RegDst_o<=0;
			MemWrite_o<=0;
			MemRead_o<=0;
			MemtoReg_o<=0;
//$display("BEQ");
		end	
	endcase
end

endmodule