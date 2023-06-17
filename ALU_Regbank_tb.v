/* Directed Test-Bench for pipelined ALU - RegBank using Verilog HDL*/

module test_pipe;
	wire zout;
	reg [3:0] rs1,rs2,rd,func;
	reg [7:0] addr;
	reg clk1,clk2;
	integer k;
	
	pipe_reg P(zout,rs1,rs2,rd,func,addr,clk1,clk2);
	
	initial
		begin
			clk1=0; clk2=0;
			repeat(20)
				begin
					#5 clk1=1; #5 clk1=0;
					#5 clk2=1; #5 clk2=0;
				end
		end
	
	initial
		for(k=0; k<16; k=k+1)
			P.regbank[k] = k;
	
	initial
		begin
			#5 rs1=3; rs2=5; rd=10; func=0;addr=125;    //SUM
			#20 rs1=3; rs2=8; rd=12; func=2;addr=126;   //MUL
			#20 rs1=10; rs2=5; rd=14; func=1;addr=128;  //SUB
			#20 rs1=7; rs2=3; rd=13; func=11;addr=127;  //SLA
			
			#60
			for(k=125; k<129; k=k+1)
				$display("Memory[%3d]=%3d",k,P.mem[k]);
		end
	
	initial
		begin
			$dumpfile("Pipeline_test.vcd");
			$dumpvars(0,test_pipe);
			$monitor("Time:%3d, Result=%3d",$time,zout);
		end
endmodule


				
