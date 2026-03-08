module arbiter(

    input req0,
    input req1,

    output reg grant0,
    output reg grant1

);

always @(*) begin

    grant0 = 0;
    grant1 = 0;

    if (req0)
        grant0 = 1;
    else if (req1)
        grant1 = 1;

end

endmodule