`timescale 1ns/1ps
// Combinational unsigned MAC: y = (a * b) + c
module mac_comb (
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire [15:0] c,
    output wire [31:0] y
);
    wire [31:0] product;
    assign product = a * b;
    assign y = product + {16'b0, c};
endmodule
