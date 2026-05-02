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
    // if(sel0)
    //     out0 = in1;
    // else
    //     out0 = in0;
    if(sel0)
        out0 = in0;
    else if(sel1)
        out0 = in1;
    else
        out0 = 8'b0;

    // output 1 selection
    // if(sel1)
    //     out1 = in1;
    // else
    //     out1 = in0;
    if(sel1)
        out1 = in1;
    else if(sel0)
        out1 = in0;
    else
        out1 = 8'b0;
    $display("[ %0t] CROSSBAR : sel0=%b sel1=%b out0=%h out1=%h",
              $time, sel0, sel1, out0, out1);

end

endmodule