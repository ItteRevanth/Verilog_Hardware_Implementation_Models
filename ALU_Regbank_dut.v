/* A Register bank with two read & 1 write of 16*16, A memory of Address Read and Write ports of 256*16, an ALU with 16 functions and 2 input */
/* Function opcodes of ALU are: ADD-0000, SUB-0001, MUL-0010, SELA-0011, SELB-0100, AND-0101, OR-0110, XOR-0111, NEGA-1000, NEGB-1001, SRA-1010, SLA-1011 */

module pipe_reg(zout,rs1,rs2,rd,func,addr,clk1,clk2);
	input [3:0] rs1,rs2,rd,func; //addresses of source,destination registers and ALU function
	input [7:0] addr;          //Address of Memory write location
	input clk1, clk2;       //Two phase clks for alternate pipes
	output zout;            //output
	
	reg [15:0] L12_A,L12_B,L23_Z,L34_Z;
	reg [3:0] L12_rd,L12_func,L23_rd;
	reg [7:0] L12_addr,L23_addr,L34_addr;
	
	reg [15:0] regbank [0:15];      //16*16 Register Bank
	reg [15:0] mem [0:255];        //256*16 memory
	
	assign zout=L34_Z;
	
	always@(posedge clk1)         //STAGE-1 of pipelining
		begin
			L12_A <= #2 regbank[rs1];
			L12_B <= #2 regbank[rs2];
			L12_rd <= #2 rd;
			L12_func <= #2 func;
			L12_addr <= #2 addr;
		end
	
	always@(posedge clk2)        //STAGE-2 of pipelining
		begin
			case(func)
				0: L23_Z <= #2 L12_A + L12_B;
				1: L23_Z <= #2 L12_A - L12_B;
				2: L23_Z <= #2 L12_A*L12_B;
				3: L23_Z <= #2 L12_A;
				4: L23_Z <= #2 L12_B;
				5: L23_Z <= #2 L12_A & L12_B;
				6: L23_Z <= #2 L12_A || L12_B;
				7: L23_Z <= #2 L12_A ^ L12_B;
				8: L23_Z <= #2 ~L12_A;
				9: L23_Z <= #2 ~L12_B;
				10: L23_Z <= #2 L12_A >>1;
				11: L23_Z <= #2 L12_A <<1;
				default: L23_Z <= #2 16'hxxxx;
			endcase
			L23_rd <= #2 L12_rd;
			L23_addr <= #2 L12_addr;
		end
	
	always@(posedge clk1)         // STAGE-3 of pipelining
		begin
			regbank[L23_rd] <= #2 L23_Z;
			L34_Z <= #2 L23_Z;
			L34_addr <= #2 L23_addr;
		end
	
	always@(posedge clk2)         //STAGE-4 of pipelining
		begin
			mem[L34_addr] <= #2 L34_Z;
		end
endmodule
		
