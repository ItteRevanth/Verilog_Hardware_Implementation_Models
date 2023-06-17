//DUT code for ParallelIn-SerialOut shift register using D-FF and MUX

module d_ff(Q,D,clk,Q_bar);    //D-FF
	input D,clk;
	output Q,Q_bar;
	wire [4:0] port;
	

	assign port[3]=Q;
	assign port[4]=Q_bar;
	nand G1(port[0],D,D);
	nand G2(port[1],D,clk);
	nand G3(port[2],port[0],clk);
	nand G4(Q,port[1],port[4]);
	nand G5(Q_bar,port[2],port[3]);
endmodule

module MUX(out,in,sel);      //MUX 2*1
	output out;
	input [1:0] in;
	input sel;
	wire [2:0] cnct;
	
	nand G1(cnct[0],sel,sel);
	and G2(cnct[1],cnct[0],in[0]);
	and G3(cnct[2],sel,in[1]);
	or G4(out,cnct[2],cnct[1]);
endmodule

module PISO(Q_out,Data,ctrl,clk,Q_bar);    //PISO module ---> main module
	input [3:0] Data;
	input clk,ctrl;
	output Q_out;
	output [3:0] D,Q_bar;
	wire [3:1] Q;
	
	MUX M0(D[0],{Q[1],Data[0]},ctrl);
	MUX M1(D[1],{Q[2],Data[1]},ctrl);
	MUX M2(D[2],{Q[3],Data[2]},ctrl);
	MUX M3(D[3],{Data[3],Data[3]},ctrl);
	
	d_ff D0(Q_out,D[0],clk,Q_bar[0]);
	d_ff D1(Q[1],D[1],clk,Q_bar[1]);
	d_ff D2(Q[2],D[2],clk,Q_bar[2]);
	d_ff D3(Q[3],D[3],clk,Q_bar[3]);
endmodule
