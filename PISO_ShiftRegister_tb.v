//Directed TestBench for PISO shift register using verilog

module PISO_test;
	reg clk,ctrl;
	wire Q0;
	wire [3:0] Qnot;
	reg [3:0] D_in;
	
	PISO sreg(Q0,D_in,ctrl,clk,Qnot); 
	initial
		begin
			clk=1'b0;
			#3 ctrl=0;
			#500 $finish;
		end
	
	always #5 clk=~clk;
	
	initial
		begin
			#2 D_in=4'b1001;
			#10 ctrl=1'b1;
		end
	initial
		begin
			$monitor($time,"output=%b",Q0);
			$dumpfile("PISO.vcd");
			$dumpvars(0,PISO_test);
		end
endmodule
