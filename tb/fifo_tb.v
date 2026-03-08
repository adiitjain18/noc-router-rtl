`timescale 1ns/1ps

module fifo_tb;

reg clk;
reg reset;

reg write_en;
reg read_en;

reg [7:0] data_in;
wire [7:0] data_out;

wire full;
wire empty;

// instantiate FIFO
fifo uut (
    .clk(clk),
    .reset(reset),
    .write_en(write_en),
    .read_en(read_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
);

// clock generation
always #5 clk = ~clk;

initial begin

    // clk = 0;
    // reset = 1;
    // write_en = 0;
    // read_en = 0;
    // data_in = 0;

    // // release reset
    // #10 reset = 0;

    // // write data into FIFO
    // #10 write_en = 1; data_in = 8'h11;
    // #10 data_in = 8'h22;
    // #10 data_in = 8'h33;
    // #10 data_in = 8'h44;

    // write_en = 0;

    // // read data from FIFO
    // #20 read_en = 1;

    // #80 read_en = 0;

    // // finish simulation
    // #20 $finish;

    clk = 0;
    reset = 1;
    write_en = 0;
    read_en = 0;
    data_in = 0;

    // release reset
    #15 reset = 0;

    // WRITE 4 VALUES
    @(posedge clk) write_en = 1; data_in = 8'h11;
    @(posedge clk) data_in = 8'h22;
    @(posedge clk) data_in = 8'h33;
    @(posedge clk) data_in = 8'h44;
    @(posedge clk) write_en = 0;

    // wait a cycle
    @(posedge clk);

    // READ 4 VALUES
    @(posedge clk) read_en = 1;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk) read_en = 0;

    // finish
    #20 $finish;

end

endmodule