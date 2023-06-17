//DUT code for 16*1 multiplexer using 2*1 multiplexers in heirarchy 

//2*1 Multiplexer structural design at gate level
module mux2to1(in,sel,out);
	input [1:0] in;
	input sel;
	output out;
	wire [2:0] t;
	
  not G1(t[0],sel);         
	and G2(t[1],in[0],t[0]);
	and G3(t[2],in[1],sel);
	or G4(out,t[2:1]);
endmodule

//4*1 multiplexer structural design in logic/block level
module mux4to1(in,sel,out);
	input [3:0] in;
	input [1:0] sel;
	output out;
	wire [1:0] t;
	
	mux2to1 M0(in[1:0],sel[0],t[0]);
	mux2to1 M1(in[3:2],sel[0],t[1]);
	mux2to1 M2(t,sel[1],out);
endmodule

//16*1 multiplexer structural design in logic/block level
module mux16to1(in,sel,out);
	input [15:0] in;
	input [3:0] sel;
	output out;
	wire [3:0] t;
	
	mux4to1 M0(in[3:0],sel[1:0],t[0]);
	mux4to1 M1(in[7:4],sel[1:0],t[1]);
	mux4to1 M2(in[11:8],sel[1:0],t[2]);
	mux4to1 M3(in[15:12],sel[1:0],t[3]);
	mux4to1 M4(t,sel[3:2],out);
endmodule
