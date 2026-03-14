module router_2port(

    input clk,
    input reset,

    input write0,
    input write1,

    input read,

    input [7:0] data_in0,
    input [7:0] data_in1,

    output [7:0] data_out

);

// FIFO outputs
wire [7:0] fifo_out0;
wire [7:0] fifo_out1;

wire full0;
wire full1;
wire empty0;
wire empty1;


// FIFO instances
fifo fifo0(
    .clk(clk),
    .reset(reset),
    .write_en(write0),
    .read_en(read),
    .data_in(data_in0),
    .data_out(fifo_out0),
    .full(full0),
    .empty(empty0)
);

fifo fifo1(
    .clk(clk),
    .reset(reset),
    .write_en(write1),
    .read_en(read),
    .data_in(data_in1),
    .data_out(fifo_out1),
    .full(full1),
    .empty(empty1)
);


// arbitration request signals
wire req0;
wire req1;

assign req0 = !empty0;
assign req1 = !empty1;


// arbiter
wire grant0;
wire grant1;

arbiter arb(
    .req0(req0),
    .req1(req1),
    .grant0(grant0),
    .grant1(grant1)
);


// crossbar
wire [7:0] out0;
wire [7:0] out1;

crossbar sw(

    .in0(fifo_out0),
    .in1(fifo_out1),

    .sel0(grant0),
    .sel1(grant1),

    .out0(out0),
    .out1(out1)

);

always @(posedge clk)
begin
    $display("[%0t] [ROUTER2] in0=%h in1=%h out=%h",
              $time, fifo_out0, fifo_out1, data_out);
end
// router output
assign data_out = out0;

endmodule