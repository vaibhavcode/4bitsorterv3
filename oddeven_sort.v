`timescale 1ns / 1ps

module oddeven_sort (
    input  wire        clk,
    input  wire        rst,
    input  wire        start,
    input  wire [15:0] din,
    output wire [15:0] dout,
    output reg  [3:0]  cycles,
    output wire        done
);
    localparam IDLE = 2'd0, RUN = 2'd1, FIN = 2'd2;

    reg [1:0]  state  = IDLE;
    reg [15:0] arr    = 16'd0;
    reg        phase  = 1'b0;   // 0 = even phase, 1 = odd phase
    reg        noswap = 1'b0;   // previous phase made no swap

    wire [3:0] a0 = arr[3:0];
    wire [3:0] a1 = arr[7:4];
    wire [3:0] a2 = arr[11:8];
    wire [3:0] a3 = arr[15:12];

    wire s01 = ~phase & (a0 < a1);
    wire s23 = ~phase & (a2 < a3);
    wire s12 =  phase & (a1 < a2);
    wire any_swap = s01 | s12 | s23;

    wire [3:0] n0 = s01 ? a1 : a0;
    wire [3:0] n1 = s01 ? a0 : (s12 ? a2 : a1);
    wire [3:0] n2 = s23 ? a3 : (s12 ? a1 : a2);
    wire [3:0] n3 = s23 ? a2 : a3;

    assign dout = arr;
    assign done = (state == FIN);

    always @(posedge clk) begin
        if (rst) begin
            state  <= IDLE;
            cycles <= 4'd0;
        end else if (start) begin
            arr    <= din;
            phase  <= 1'b0;
            noswap <= 1'b0;
            cycles <= 4'd0;
            state  <= RUN;
        end else if (state == RUN) begin
            arr    <= {n3, n2, n1, n0};
            cycles <= cycles + 4'd1;
            phase  <= ~phase;
            noswap <= ~any_swap;
            if (cycles == 4'd3 || (~any_swap && noswap))
                state <= FIN;
        end
    end
endmodule
