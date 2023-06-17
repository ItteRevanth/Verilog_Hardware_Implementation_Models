//Directed testbench code for 16-bit ripple carry adder

module alutest;
	reg [15:0] X,Y; wire [15:0] Z; wire CR,S,ZR,P,V;
	ALU A(.X(X),.Y(Y),.Z(Z),.carry(CR),.sign(S),.zero(ZR),.parity(P),.overflow(V));
	initial
		begin
			$dumpfile("alutest.vcd");
			$dumpvars(0,alutest);
			$monitor($time,"X=%h,Y=%h,Z=%h,CR=%b,S=%b,ZR=%b,P=%b,V=%b",X,Y,Z,CR,S,ZR,P,V);
			#5 X=16'h8fff; Y=16'h8000;
			#5 X=16'hfffe; Y=16'h0002;
			#5 X=16'haaaa; Y=16'h5555;
			#5 $finish;
		end
endmodule
