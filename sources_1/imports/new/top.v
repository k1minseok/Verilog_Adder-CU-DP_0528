`timescale 1ns / 1ps

module top (
    input clk,
    input reset,

    output [7:0] fndFont,
    output [3:0] fndCom,
    output [7:0] out
);
    // wire [7:0] w_outcount;

    DedicatedProcessor U_DP (
        .clk  (clk),
        .reset(reset),

        .out(out)
    );


    fndContorller U_FNDController (
        .reset(reset),
        .clk  (clk),
        .digit({6'b0, out}),

        .fndFont(fndFont),
        .fndCom (fndCom)

    );

endmodule
