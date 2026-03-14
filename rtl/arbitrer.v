module arbiter(

    input req0,
    input req1,

    output reg grant0,
    output reg grant1

);

always @(*) begin

    grant0 = 0;
    grant1 = 0;

    if(req0) begin
        grant0 = 1;
        $display("[TIME %0t] ARBITER : req0=%b req1=%b -> grant0", $time, req0, req1);
    end
    else if(req1) begin
        grant1 = 1;
        $display("[TIME %0t] ARBITER : req0=%b req1=%b -> grant1", $time, req0, req1);
    end

end

endmodule