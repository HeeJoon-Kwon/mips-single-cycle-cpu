`timescale 100ps / 100ps

module ALU(
    input [15:0] A,
    input [15:0] B,
    input Cin,
    input [3:0] OP,
    output reg Cout,
    output reg [15:0] C
    );
    
    // FILLME
reg [16:0] true_sum;

parameter [3:0] OP_ADD = 4'b0000,
		OP_SUB = 4'b0001,
		OP_ID = 4'b0010,
		OP_NAND = 4'b0011,
		OP_NOR = 4'b0100,
		OP_XNOR = 4'b0101,
		OP_NOT = 4'b0110,
		OP_AND = 4'b0111,
		OP_OR = 4'b1000,
		OP_XOR = 4'b1001,
		OP_LRS = 4'b1010,
		OP_ARS = 4'b1011,
		OP_RR = 4'b1100,
		OP_LLS = 4'b1101,
		OP_ALS = 4'b1110,
		OP_RL = 4'b1111;

always @ (A, B, Cin, OP) begin
	true_sum = 0;
	C = 0;
	Cout = 0;

	case(OP)
		OP_ADD: begin
			true_sum = A + B + Cin;
			C = true_sum[15:0];
			Cout = true_sum[16];
		end
		OP_SUB: begin
			C = A - (B + Cin);
			true_sum = B + Cin;
			if (true_sum > A) Cout = 1; else Cout = 0;
		end
		OP_ID: begin
			C = A;
		end
		OP_NAND: begin 
			C = ~(A&B);
		end
		OP_NOR: begin
			C = ~(A|B);
		end
		OP_XNOR: begin
			C = ~(A^B);
		end
		OP_NOT: begin
			C = ~A;
		end
		OP_AND: begin
			C = A&B;
		end
		OP_OR: begin
			C = A|B;
		end
		OP_XOR: begin
			C = A^B;
		end
		OP_LRS: begin
			C = A>>1;
		end
		OP_ARS: begin
			C = $signed(A)>>>1;
		end
		OP_RR: begin
			C = {A[0], A[15:1]};
		end
		OP_LLS: begin
			C = A<<1;
		end
		OP_ALS: begin
			C = $signed(A)<<<1;
		end
		OP_RL: begin
			C = {A[14:0],A[15]};
		end
	endcase
end

endmodule
