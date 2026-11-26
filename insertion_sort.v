`timescale 1ns / 1ps

module insertion_sort (
    input  wire        clk,
    input  wire        rst,
    input  wire        start,
    input  wire [15:0] din,
    output wire [15:0] dout,
    output reg  [3:0]  cycles,
    output wire        done
);
    localparam IDLE = 2'd0, RUN = 2'd1, FIN = 2'd2;

    reg [1:0]  state = IDLE;
    reg [15:0] arr   = 16'd0;
    reg [2:0]  i     = 3'd1;
    reg [2:0]  j     = 3'd1;

    wire [3:0] cur  = arr[j*4 +: 4];
    wire [3:0] prev = arr[(j-1)*4 +: 4];
    wire       swap      = (cur > prev);
    wire       inner_end = ~swap | (j == 3'd1);

    assign dout = arr;
    assign done = (state == FIN);

    always @(posedge clk) begin
        if (rst) begin
            state  <= IDLE;
            cycles <= 4'd0;
        end else if (start) begin
            arr    <= din;
            i      <= 3'd1;
            j      <= 3'd1;
            cycles <= 4'd0;
            state  <= RUN;
        end else if (state == RUN) begin
            cycles <= cycles + 4'd1;
            if (swap) begin
                arr[j*4 +: 4]     <= prev;
                arr[(j-1)*4 +: 4] <= cur;
            end
            if (inner_end) begin
                if (i == 3'd3) state <= FIN;
                else begin
                    i <= i + 3'd1;
                    j <= i + 3'd1;
                end
            end else
                j <= j - 3'd1;
        end
    end
endmodule
