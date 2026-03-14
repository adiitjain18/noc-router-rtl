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
always @(posedge clk)
    if(read_en && !empty)
        $display("Time=%0t  Data Read=%h", $time, data_out);

initial begin

    clk = 0;
    reset = 1;
    write_en = 0;
    read_en = 0;
    data_in = 0;
   

    // // Problem arised here: 
        // // In the simulation, the last data_out 44 was not visible, suspects were the testbench timing and FIFO RTL.
        // // So tried to fix it in multiple attempts.

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
    // // Solution attempt - 1 : Initially these were the delays 
    // #40 read_en = 0;

    // #50 $finish;

    // //Tried to solve the below way giving the testbench enough time to end since the time taken for each value was 10 ns.
    // #80 read_en = 0;

    // // finish simulation
    // #20 $finish;
    // // This didn't work out so went for below solution.

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