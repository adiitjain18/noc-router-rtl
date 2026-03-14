`timescale 1ns/1ps

module router_tb;

reg clk;
reg reset;

reg write_en;
reg read_en;

reg [7:0] data_in;
wire [7:0] data_out;

// instantiate router
router uut(

    .clk(clk),
    .reset(reset),

    .write_en(write_en),
    .read_en(read_en),

    .data_in(data_in),
    .data_out(data_out)

);


// clock generation
always #5 clk = ~clk;
initial begin
    $monitor("[ %0t] TB : data_in=%h write=%b read=%b data_out=%h",
              $time, data_in, write_en, read_en, data_out);
end

initial begin

    clk = 0;
    reset = 1;
    write_en = 0;
    read_en = 0;
    data_in = 0;

    // release reset
    #15 reset = 0;

    // send packets
    @(posedge clk) write_en = 1; data_in = 8'b01_000001;
    @(posedge clk) data_in = 8'b10_000010;
    @(posedge clk) data_in = 8'b11_000011;
    @(posedge clk) write_en = 0;

    // start reading
    @(posedge clk) read_en = 1;
    repeat(5) @(posedge clk);

    read_en = 0;

    #20 $finish;

end

endmodule