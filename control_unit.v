module control_unit(
    input [15:0] data,
    output reg [1:0] SA,
    output reg [1:0] SB,
    output reg LD,
    output reg [1:0] DR,
    output reg MB,
    output reg MP,
    output reg MD,
    output reg [15:0] IMM,
    output reg [11:0] OFF
);

wire [3:0] op = data[15:12];
wire [1:0] rs = data[11:10];
wire [1:0] rt = data[9:8];
wire [1:0] rd = data[7:6];
wire [5:0] func_code = data[5:0];
wire [7:0] imm = data[7:0];
wire [11:0] off = data[11:0];

parameter [3:0] R_TYPE = 4'hF,
                JMP = 4'h9,
                LHI = 4'h6,
                ADI = 4'h4;

parameter [5:0] ADD = 6'h00,
                WWD = 6'h1c;

always @(*) begin
    SA  = 2'b00;
    SB  = 2'b00;
    LD  = 1'b0;
    DR  = 2'b00;
    MB  = 1'b0;
    MP  = 1'b0;
    MD  = 1'b0;
    IMM = 16'b0;
    OFF = 12'b0;

    case (op)
        R_TYPE: begin
            case (func_code)
                ADD: begin
                    SA = rs;
                    SB = rt;
                    LD = 1'b1;
                    DR = rd;
                    MB = 1'b0;
                    MD = 1'b0;
                end
                WWD: begin
                    SA = rs;
                    LD = 1'b0;
                end
                default: begin end
            endcase
        end

        JMP: begin
            MP  = 1'b1;
            OFF = off;
        end

        LHI: begin
            LD  = 1'b1;
            DR  = rt;
            MB  = 1'b1;
            MD  = 1'b1;
            IMM = {imm, 8'b0};
        end

        ADI: begin
            SA  = rs;
            LD  = 1'b1;
            DR  = rt;
            MB  = 1'b1;
            MD  = 1'b0;
            IMM = {{8{imm[7]}}, imm};
        end

        default: begin end
    endcase
end

endmodule