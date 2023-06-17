//Directed testbench code for 4*16 decoder in verilog 

module decoder4to16_test;
	reg [3:0] I; reg en; wire [0:15] D;
	decoder4to16 M(.in(I),.en(en),.D(D));
	initial
		begin
			$dumpfile("decoder4to16.vcd");
			$dumpvars(0,decoder4to16_test);
			$monitor($time,"I=%h, D=%h", I,D);
			#5 I=4'h0; en=1'b1; 
			#5 I=4'h6;
			#5 I=4'ha;
			#5 I=4'hf;
			#5 $finish;
		end
endmodule
