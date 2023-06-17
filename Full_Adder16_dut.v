//DUT code for 16-bit Ripple Carry Adder using simple full-adders in heirarchy

//Full-Adder structural design at gate level
module fulladder(C1,X,Y,Z,C);
	input C1,X,Y; output Z,C; wire [3:1] t;

	xor G1(t[1],X,Y);
	nand G2(t[2],X,Y);
	xor G3(Z,t[1],C1);
	nand G4(t[3],t[1],C1);
	nand G5(C,t[2],t[3]);
endmodule

//4-bit adder structural design at block level
module adder4(C1,X,Y,Z,C);
	input [3:0]X,Y; input C1;
	output [3:0] Z; output C;
	wire [2:0] t;
	
	fulladder A0(1'b0,X[0],Y[0],Z[0],t[2]);
	fulladder A1(t[2],X[1],Y[1],Z[1],t[1]);
	fulladder A2(t[1],X[2],Y[2],Z[2],t[0]);
	fulladder A3(t[0],X[3],Y[3],Z[3],C);
endmodule

//16-bit adder structural design at block level
module ALU(X,Y,Z,sign,carry,zero,parity,overflow);
	input [15:0] X,Y;
	output [15:0] Z;
	output carry,sign,zero,parity,overflow;
	wire [2:0] t;
	
	assign sign=Z[15];
	assign zero=~|Z;
	assign parity=~^Z;
	assign overflow=(X[15]&Y[15]&~Z[15])|(~X[15]&~Y[15]&Z[15]);
	adder4 A0(1'b0,X[3:0],Y[3:0],Z[3:0],t[2]);
	adder4 A1(t[2],X[7:4],Y[7:4],Z[7:4],t[1]);
	adder4 A2(t[1],X[11:8],Y[11:8],Z[11:8],t[0]);
	adder4 A3(t[0],X[15:12],Y[15:12],Z[15:12],carry);
endmodule
