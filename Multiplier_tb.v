//Dirceted Test-Bench for multiplier using Verilog HDL

module AMUL_test;
	reg [15:0] data_in;
	reg clk,start;
	wire done;
	
	MUL test(eqz,ldA,ldB,ldP,clrP,decB,data_in,clk);
	controller cont(ldA,ldB,ldP,clrP,done,decB,start,clk,eqz);
	
	initial
		begin
			clk=1'b0;
			#3 start=1;
			#500 $finish;
		end
	
	always #5 clk=~clk;
	
	initial
		begin
			#17 data_in=17;
			#10 data_in=5;
		end
	
	initial
		begin
			$monitor($time,"%d %b", test.Y,done);
			$dumpfile("AMUL.vcd");
			$dumpvars(0,AMUL_test);
		end
endmodule
