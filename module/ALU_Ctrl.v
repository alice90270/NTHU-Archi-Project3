//Subject:     Architecture project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`define ADD 6'h20
`define SUB 6'h22
`define AND 6'h24
`define OR 6'h25
`define SLT 6'h2a

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [8-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

//Select exact operation, please finish the following code
always@(funct_i or ALUOp_i) begin
	case(ALUOp_i)
        8'h00: begin //R-type
                case(funct_i)
                    `AND:	ALUCtrl_o <= 4'b0000; //0
					`OR:	ALUCtrl_o <= 4'b0001; //1
					`ADD:	ALUCtrl_o <= 4'b0010; //2
					`SUB:	ALUCtrl_o <= 4'b0110; //6
					`SLT:	ALUCtrl_o <= 4'b0111; //7
                    default: ALUCtrl_o = 4'b1111;
                endcase
            end
		8'h08: //ADDI
			ALUCtrl_o <= 4'b0010;
		8'h23: //LW
			ALUCtrl_o <= 4'b0010;
		8'h2B: //SW
			ALUCtrl_o <= 4'b0010;
		8'h0A: //SLTI
			ALUCtrl_o <= 4'b0111;
		8'h04: //BEQ
			ALUCtrl_o <= 4'b0110;
        default:
			ALUCtrl_o <= 4'b0010;
    endcase
	//$display("ALUOp_i=%h",ALUOp_i);	
	//$display("funct_i=%h",funct_i);
	//$monitor("ALU ctrl=%b",ALUCtrl_o);
end
endmodule
