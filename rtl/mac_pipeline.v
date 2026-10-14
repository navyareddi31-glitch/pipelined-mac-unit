`timescale 1ns/1ps
// Two-stage pipelined unsigned MAC.
// Stage 1 registers product and matching C; stage 2 registers the sum.
// Synchronous active-high reset.
module mac_pipeline (
    input  wire        clk,
    input  wire        rst,
    input  wire        in_valid,
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire [15:0] c,
    output reg         out_valid,
    output reg  [31:0] y
);
    reg [31:0] product_reg;
    reg [15:0] c_reg;
    reg        valid_stage1;

    always @(posedge clk) begin
        if (rst) begin
            product_reg  <= 32'd0;
            c_reg        <= 16'd0;
            valid_stage1 <= 1'b0;
            y            <= 32'd0;
            out_valid    <= 1'b0;
        end else begin
            product_reg  <= a * b;
            c_reg        <= c;
            valid_stage1 <= in_valid;
            y            <= product_reg + {16'b0, c_reg};
            out_valid    <= valid_stage1;
        end
    end
endmodule
