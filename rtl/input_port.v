module input_port(

    input clk,
    input reset,

    input write_en,
    input read_en,

    input  [7:0] data_in,
    output [7:0] data_out,

    output north,
    output east,
    output west,
    output local

);

// FIFO instance
wire full;
wire empty;

fifo fifo_inst(

    .clk(clk),
    .reset(reset),
    .write_en(write_en),
    .read_en(read_en),

    .data_in(data_in),
    .data_out(data_out),

    .full(full),
    .empty(empty)

);


// destination bits
wire [1:0] dest;

assign dest = data_out[7:6];


// routing logic instance
routing_logic route_inst(

    .dest(dest),

    .north(north),
    .east(east),
    .west(west),
    .local(local)

);

endmodule