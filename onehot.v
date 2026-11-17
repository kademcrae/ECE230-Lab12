// State bits [4:0] correspond to E, D, C, B, A.
module onehot(
    input w,
    input clk,
    input reset,
    output z,
    output [4:0] state
);
    wire [4:0] next;

    dff a(
        .Default(1'b1), 
        .D(next[0]), 
        .clk(clk), 
        .reset(reset), 
        .Q(state[0])
    );
    dff b(
        .Default(1'b0), 
        .D(next[1]), 
        .clk(clk), 
        .reset(reset), 
        .Q(state[1])
    );
    dff c(
        .Default(1'b0), 
        .D(next[2]), 
        .clk(clk), 
        .reset(reset), 
        .Q(state[2])
    );
    dff d(
        .Default(1'b0), 
        .D(next[3]), 
        .clk(clk), 
        .reset(reset), 
        .Q(state[3])
    );
    dff e(
        .Default(1'b0), 
        .D(next[4]), 
        .clk(clk), 
        .reset(reset), 
        .Q(state[4])
    );

    // A is entered only at initialization or reset.
    assign next[0] = 1'b0;
    assign next[1] = ~w & (state[0] | state[3] | state[4]);
    assign next[2] = ~w & (state[1] | state[2]);
    assign next[3] = w & (state[0] | state[1] | state[2]);
    assign next[4] = w & (state[3] | state[4]);
    assign z = state[2] | state[4];
endmodule
