module crossbar(

    input  [7:0] in0,
    input  [7:0] in1,

    input sel0,
    input sel1,

    output reg [7:0] out0,
    output reg [7:0] out1

);

always @(*) begin

    // output 0 selection
    if(sel0)
        out0 = in1;
    else
        out0 = in0;

    // output 1 selection
    if(sel1)
        out1 = in1;
    else
        out1 = in0;

end

endmodule