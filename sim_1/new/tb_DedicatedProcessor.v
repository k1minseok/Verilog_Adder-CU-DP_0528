`timescale 1ns / 1ps

module tb_DedicatedProcessor ();
    reg clk;
    reg reset;

    wire [7:0] fndFont;
    wire [3:0] fndCom;
    wire [7:0] out;


    top dut (
        .clk  (clk),
        .reset(reset),

        .fndFont(fndFont),
        .fndCom(fndCom),
        .out(out)
    );

    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        reset = 1;

        #30 reset = 0;
    end
endmodule
