module input_port(

    input clk,
    input reset,

    input write_en,
    input read_en,

    input  [7:0] data_in,
    output [7:0] data_out,

    output [7:0] head_data,

    output north,
    output east,
    output west,
    output local_out

);

// FIFO instance
wire full;
wire full;
wire empty;
// wire [7:0] head_data;

fifo fifo_inst(

    .clk(clk),
    .reset(reset),
    .write_en(write_en),
    .read_en(read_en),

    .data_in(data_in),
    .data_out(data_out),

    .full(full),
    .empty(empty),

    .head_data(head_data)

);


// destination bits
wire [1:0] dest;

// assign dest = data_out[7:6];
assign dest = head_data[7:6];


// routing logic instance
routing_logic route_inst(

    .dest(dest),

    .north(north),
    .east(east),
    .west(west),
    .local_out(local_out)

);

endmodule