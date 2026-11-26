`timescale 1ns / 1ps

module sort_core (
    input  wire        clk,
    input  wire        rst,
    input  wire        start,
    input  wire [15:0] din,        
    output wire [15:0] ins_out,
    output wire [3:0]  ins_cycles,
    output wire        ins_done,
    output wire [15:0] oe_out,
    output wire [3:0]  oe_cycles,
    output wire        oe_done
);
    insertion_sort u_ins (
        .clk(clk), .rst(rst), .start(start), .din(din),
        .dout(ins_out), .cycles(ins_cycles), .done(ins_done)
    );

    oddeven_sort u_oe (
        .clk(clk), .rst(rst), .start(start), .din(din),
        .dout(oe_out), .cycles(oe_cycles), .done(oe_done)
    );
endmodule
