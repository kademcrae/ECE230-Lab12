// Binary encoding: A=000, B=001, C=010, D=011, E=100.
module binary(
    input w,
    input clk,
    input reset,
    output z,
    output [2:0] state
);
    wire [2:0] next;
    wire in_zero_run;
    wire in_one_run;
    wire enter_d;

    dff bit0(
        .Default(1'b0), 
        .D(next[0]), 
        .clk(clk), 
        .reset(reset), 
        .Q(state[0])
    );
    dff bit1(
        .Default(1'b0), 
        .D(next[1]), 
        .clk(clk), 
        .reset(reset), 
        .Q(state[1])
    );
    dff bit2(
        .Default(1'b0), 
        .D(next[2]), 
        .clk(clk), 
        .reset(reset), 
        .Q(state[2])
    );

    // B/C mean the previous input was zero; D/E mean it was one.
    // These equations use unused encodings 101, 110, 111 as don't-cares.
    assign in_zero_run = state[1] ^ state[0];
    assign in_one_run = state[2] | (state[1] & state[0]);
    assign enter_d = w & ~in_one_run;

    // For w=0, enter B (001) or stay/advance to C (010).
    // For w=1, enter D (011) or stay/advance to E (100).
    assign next[0] = enter_d | (~w & ~in_zero_run);
    assign next[1] = enter_d | (~w & in_zero_run);
    assign next[2] = w & in_one_run;
    assign z = (state == 3'b010) | (state == 3'b100);
endmodule
