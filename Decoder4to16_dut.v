//DUT code for 4*16 decoder using 1*2 decoders in heirarchial design 

//1*2 decoder structural design at gate level
module decoder1to2(in,en,D);
	input in;
	input en;
	output [1:0] D;
	wire t;
	
	not G1(t,in);
	and G2(D[0],en,t);
	and G3(D[1],en,in);
endmodule

//2*4 decoder structural design at logic/block level
module decoder2to4(in,en,D);
	input [1:0] in;
	input en;
	output [3:0] D;
	wire [1:0] t;
	
	decoder1to2 D0(in[1],1'b1,t[1:0]);
	decoder1to2 D1(in[0],t[0],D[1:0]);
	decoder1to2 D2(in[0],t[1],D[3:2]);
endmodule

//4*16 decoder structural design at logic/block level
module decoder4to16(in,en,D);
	input [3:0] in;
	input en;
	output [15:0] D;
	wire [3:0] t;
	
	decoder2to4 D0(in[3:2],1'b1,t[3:0]);
	decoder2to4 D1(in[1:0],t[0],D[3:0]);
	decoder2to4 D2(in[1:0],t[1],D[7:4]);
	decoder2to4 D3(in[1:0],t[2],D[11:8]);
	decoder2to4 D4(in[1:0],t[3],D[15:12]);
endmodule
