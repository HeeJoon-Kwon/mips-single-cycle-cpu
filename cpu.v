///////////////////////////////////////////////////////////////////////////
// MODULE: CPU for TSC microcomputer: cpu.v
// Description: single cycle cpu

// DEFINITIONS
`define WORD_SIZE 16    // data and address word size

// MODULE DECLARATION
module cpu (
    output readM,                       // read from memory
    output [`WORD_SIZE-1:0] address,    // current address for data
    inout [`WORD_SIZE-1:0] data,        // data being input or output
    input inputReady,                   // indicates that data is ready from the input port
    input reset_n,                      // active-low RESET signal
    input clk,                          // clock signal
  
    // for debuging/testing purpose
    output [`WORD_SIZE-1:0] num_inst,   // number of instruction during execution
    output [`WORD_SIZE-1:0] output_port // this will be used for a "WWD" instruction
);

reg [`WORD_SIZE-1:0] PC;
wire [`WORD_SIZE-1:0] next_PC;
reg [`WORD_SIZE-1:0] instr;
reg [`WORD_SIZE-1:0] num_inst_reg;
reg prev_inputReady;
reg prev_prev_inputReady;

wire [1:0] SA, SB, DR;
wire LD, MB, MP, MD;
wire [15:0] IMM;
wire [11:0] OFF;

assign address = PC;
assign readM = 1;

always @(posedge clk) begin
    if (!reset_n) begin
        PC <= 0;
        instr <= 0;
        prev_inputReady <= 0;
        prev_prev_inputReady <= 0;
    end
    else begin
        prev_prev_inputReady <= prev_inputReady;
        prev_inputReady <= inputReady;
        
        if (inputReady) begin
            instr <= data;
        end
        
        if (prev_inputReady) begin
            PC <= next_PC;
        end
    end
end

control_unit U1(
    .data(instr),
    .SA(SA),
    .SB(SB),
    .LD(LD),
    .DR(DR),
    .MB(MB),
    .MP(MP),
    .MD(MD),
    .IMM(IMM),
    .OFF(OFF)
);

assign next_PC = MP ? {PC[15:12], OFF} : PC + 1;

datapath U2 (
    .clk(clk),
    .SA(SA),
    .SB(SB),
    .LD(LD && prev_inputReady),
    .DR(DR),
    .reset_n(reset_n),
    .MB(MB),
    .MD(MD),
    .IMM(IMM),
    .output_port(output_port)
);

assign num_inst = num_inst_reg;

always @(posedge clk) begin
    if (!reset_n) begin
        num_inst_reg <= 0;
    end
    else if (prev_prev_inputReady) begin
        num_inst_reg <= PC;
    end
end

endmodule
