// Code your testbench here
// or browse Examples
/* The controller and datapath code for multiplication using the repititive additiion technique */
                                 /* THE DATA PATH CODE*/

//The PIPO register having only load input for multiplicant storing
module PIPO1(out,in,load,clk);
	output reg [15:0] out;
	input [15:0] in;
	input load,clk;
	
	always@(posedge clk)       //At clock rise, give output as same as input - D flip-flop
		if(load) out<=in;
endmodule

//The PIPO register with load and clear inputs for product storing
module PIPO2(out,in,load,clr,clk);
	output reg [15:0] out;
	input [15:0] in;
	input load,clr,clk;
	
	always@(posedge clk)
		if(clr) out<=16'b0;      //If clear, make output to zero
		else if(load) out<=in;   //If load make output as input - D flip-flop
endmodule

//The downcounter for multiplier
module count(out,in,load,dec,clk);
	output reg [15:0] out;
	input [15:0] in;
	input load,dec,clk;
	
	always@(posedge clk)        // After every addition decrease the multiplier by 1;
		if(dec) out<=out-1;
		else if(load) out<=in;   // At start to load multiplier from data input
endmodule

//The adder module for repetitive addition of multiplicant with product until multiplier is not zero
module adder(sum,A,B);
	output reg [15:0] sum;
	input [15:0] A,B;
	
	always@(*)
		sum<=A+B; //Adding the multiplicant to the product
endmodule

// Module for comparing wether multiplier is zero after every iterative addition
module comp(out,in);
	output out;
	input [15:0] in;
	
	assign out = (in==0);  //If multiplier is zero, 'out' flag is made 1 to stop addition iteration
endmodule 

/* The master module that implements multiplication by instantiating above modules */
module MUL(eqz,ldA,ldB,ldP,clrP,decB,data_in,clk);
	input [15:0] data_in;
	input ldA,ldB,ldP,clrP,decB,clk;
	output eqz;
	wire [15:0]X,Y,Z,Bout;
	
	PIPO1 A(X,data_in,ldA,clk);          //PIPO regitser of I kind
	PIPO2 B(Y,Z,ldP,clrP,clk);           //PIPO register of II kind
	adder C(Z,X,Y);                      //Adder
	count D(Bout,data_in,ldB,decB,clk);  //Down counter
	comp E(eqz,Bout);                    //Comparator
endmodule

                            /* THE CONTROL PATH CODE */

// The controller to generate the signals for data path to carry on computation
module controller(ldA,ldB,ldP,clrP,done,decB,start,clk,eqz);
	output reg ldA,ldB,ldP,clrP,done,decB;
	input start,eqz,clk;
	reg [2:0] state;
	
	parameter S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100;
	
	always@(posedge clk)
		begin
			case(state)
				S0: if(start) state<=S1;   // If asked to start move to state 1
				S1: state<=S2;             //Move to state 2
				S2: state<=S3;             //Move to state 3
				S3: #2 if(eqz) state<=S4;  // If multiplier is zero go to state 4 otherwise stay here
				S4: state<=S4;             // End the additive iteration process
				default: state<=S0;        
			endcase
		end

	always@(state)
		begin
			case(state)
				S0: begin #1 ldA=0; ldB=0; ldP=0; clrP=0; done=0; decB=0; end       //Make all control signals to zero
				S1: begin #1 ldA=1; end                                             //load the A(multiplicant)input
				S2: begin #1 ldA=0; ldB=1; clrP=1; end                              //Load the B(multiplier) input and clear the product register
				S3: begin #1 ldB=0; clrP=0; ldP=1; decB=1; end                      //Add the sum to product snd decrease the B by 1
				S4: begin #1 ldP=0; decB=0; done=1; end                             // Make 'done =1' and end the process
				default: begin #1 ldA=0; ldB=0; ldP=0; clrP=0; done=0; decB=0; end
			endcase
		end
endmodule
		
