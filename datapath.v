module datapath(
    input clk,
    input [1:0] SA,
    input [1:0] SB,
    input LD,
    input [1:0] DR,
    input reset_n,
    input MB,
    input MD,
    input [15:0] IMM,
    output [15:0] output_port
);

wire [15:0] rf_data1;
wire [15:0] rf_data2;
wire [15:0] alu_input_b;
wire [15:0] alu_output;
wire [15:0] rf_write_data;
wire alu_cout;

reg [15:0] output_port_reg;
reg [1:0] prev_SA;

RF register_file (
    .addr1(SA),
    .addr2(SB),
    .addr3(DR),
    .data3(rf_write_data),
    .write(LD),
    .clk(clk),
    .reset(~reset_n),
    .data1(rf_data1),
    .data2(rf_data2)
);

assign alu_input_b = MB ? IMM : rf_data2;

ALU alu (
    .A(rf_data1),
    .B(alu_input_b),
    .Cin(1'b0),
    .OP(4'b0000),
    .Cout(alu_cout),
    .C(alu_output)
);

assign rf_write_data = MD ? IMM : alu_output;

always @(posedge clk) begin
    if (!reset_n) begin
        output_port_reg <= 16'b0;
        prev_SA <= 2'b0;
    end
    else begin
        prev_SA <= SA;
        output_port_reg <= register_file.register[prev_SA];
    end
end

assign output_port = output_port_reg;

endmodule