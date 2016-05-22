//Subject:     Architecture project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
wire             zero_o;

//Parameter

//Main function
always@(*)begin
	case(ctrl_i)
		4'b0000://AND
		begin	
			result_o <= src1_i & src2_i;
		//$display("=====AND=====");
		end
		4'b0001://OR
		begin
			result_o <= src1_i | src2_i;
		//$display("======OR=====");
		end
		4'b0010://ADD
		begin
			result_o <= src1_i + src2_i;
		//$display("=====ADD======");
		end
		4'b0110://SUB BEQ
		begin
			result_o <= src1_i - src2_i;
		//$display("=====SUB======");
		end
		4'b0111:begin//SLT
			if($signed(src1_i)<$signed(src2_i))
				result_o <= 1;
			else
				result_o <= 0;
		//$display("=====SLT=====");
		end	
//		default:
			//result_o <= src1_i + src2_i;
	endcase				
	//$display("src1:%d src2:%d crtl:%d result:%d zero:%d",src1_i,src2_i,ctrl_i,result_o,zero_o);

end
assign zero_o = (result_o == 0) ? 1 : 0;
endmodule




