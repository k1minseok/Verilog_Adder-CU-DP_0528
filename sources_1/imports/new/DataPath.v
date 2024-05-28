`timescale 1ns / 1ps

module DataPath (
    input clk,
    input reset,
    input ASrcMuxSel,
    input ALoad,
    input StateRegEn,

    output ALt10,
    output [7:0] out
);

    wire [7:0] w_AdderResult, w_SumResult, w_AMuxOut, w_SumMuxOut, w_ARegOut, w_SumRegOut;

    mux_2x1 U_MUX_A (
        .sel(ASrcMuxSel),
        .a  (8'b0),
        .b  (w_AdderResult),

        .y(w_AMuxOut)
    );

    mux_2x1 U_MUX_Sum (
        .sel(ASrcMuxSel),
        .a  (8'b0),
        .b  (w_SumResult),

        .y(w_SumMuxOut)
    );

    register U_A_Reg (
        .clk(clk),
        .reset(reset),
        .load(ALoad),
        .d(w_AMuxOut),

        .q(w_ARegOut)
    );

    register U_Sum_Reg (
        .clk(clk),
        .reset(reset),
        .load(ALoad),
        .d(w_SumMuxOut),

        .q(w_SumRegOut)
    );

    comparator U_Comp (
        .a(w_ARegOut),
        .b(8'd11),

        .lt(ALt10)
    );

    adder U_Adder_A (
        .a(w_ARegOut),
        .b(8'b1),

        .y(w_AdderResult)
    );

    adder U_Adder_Sum (
        .a(w_AdderResult),
        .b(w_SumRegOut),

        .y(w_SumResult)
    );

    // outBuff U_OutBuf (
    //     .en(OutBufSel),
    //     .a (w_ARegOut),

    //     .y(out)
    // );

    register U_Out_Reg (
        .clk(clk),
        .reset(reset),
        .load(StateRegEn),
        .d(w_SumRegOut),

        .q(out)
    );       

endmodule


module mux_2x1 (
    input [7:0] a,
    input [7:0] b,
    input sel,

    output reg [7:0] y
);

    always @(*) begin
        case (sel)
            1'b0: y = a;
            1'b1: y = b;
        endcase
    end
endmodule

module register (
    input clk,
    input reset,
    input load,
    input [7:0] d,
    output [7:0] q
);
    reg [7:0] d_reg, d_next;
    assign q = d_reg;

    always @(posedge clk, posedge reset) begin
        if (reset) d_reg <= 0;
        else d_reg <= d_next;
    end

    always @(*) begin
        if (load) d_next = d;
        else d_next = d_reg;
    end
endmodule


module comparator (
    input [7:0] a,
    input [7:0] b,

    output lt
);
    assign lt = a < b;
endmodule


module adder (
    input [7:0] a,
    input [7:0] b,

    output [7:0] y
);
    assign y = a + b;
endmodule


module outBuff (
    input en,
    input [7:0] a,

    output [7:0] y
);
    assign y = en ? a : 8'bz;  // en이 1 -> a, en이 0 -> high impedence 
endmodule
