`timescale 1ns/1ps

module counter_tb;

reg clk;
reg reset;
wire [3:0] count;

counter uut (
    .clk(clk),
    .reset(reset),
    .count(count)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;

    #10 reset = 0;

    #100 $finish;
end

endmodule