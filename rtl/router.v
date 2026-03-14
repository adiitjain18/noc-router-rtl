module router(

    input clk,
    input reset,

    input write_en,
    input read_en,

    input  [7:0] data_in,
    output [7:0] data_out

);

// signals
wire [7:0] fifo_out;

wire north;
wire east;
wire west;
wire local;

wire grant0;
wire grant1;

wire [7:0] cross_out0;
wire [7:0] cross_out1;

reg [7:0] stage1;
reg [7:0] stage2;
reg [7:0] stage3;

parameter USE_RR_ARBITER = 0;
// Input Port
input_port in_port(

    .clk(clk),
    .reset(reset),
    .write_en(write_en),
    .read_en(read_en),
    .data_in(data_in),
    .data_out(fifo_out),

    .north(north),
    .east(east),
    .west(west),
    .local(local)

);

generate

if(USE_RR_ARBITER) begin

    arbiter_rr arb(
        .clk(clk),
        .reset(reset),
        .req0(north),
        .req1(east),
        .grant0(grant0),
        .grant1(grant1)
    );

end
else begin

    arbiter_fixed arb(
        .req0(north),
        .req1(east),
        .grant0(grant0),
        .grant1(grant1)
    );

end

endgenerate

// Arbiter
// arbiter arb(

//     .req0(north),
//     .req1(east),

//     .grant0(grant0),
//     .grant1(grant1)

// );


// Crossbar
crossbar sw(

    .in0(fifo_out),
    .in1(fifo_out),

    .sel0(grant0),
    .sel1(grant1),

    .out0(cross_out0),
    .out1(cross_out1)

);

// arbiter arb(

//     .clk(clk),
//     .reset(reset),

//     .req0(north),
//     .req1(east),

//     .grant0(grant0),
//     .grant1(grant1)

// );
always @(posedge clk) begin
    $display("[ %0t] ROUTER : data_in=%h data_out=%h",
              $time, data_in, data_out);
end

always @(posedge clk) begin

    stage1 <= fifo_out;

    stage2 <= stage1;

    stage3 <= stage2;

end
// router output
assign data_out = cross_out0;

endmodule