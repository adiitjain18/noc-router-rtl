module arbiter_rr(

    input clk,
    input reset,

    input req0,
    input req1,

    output reg grant0,
    output reg grant1

);

reg last_grant;

always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        grant0 <= 0;
        grant1 <= 0;
        last_grant <= 0;
    end
    else
    begin
        grant0 <= 0;
        grant1 <= 0;

        case(last_grant)

        0:
        begin
            if(req1)
            begin
                grant1 <= 1;
                last_grant <= 1;
            end
            else if(req0)
            begin
                grant0 <= 1;
                last_grant <= 0;
            end
        end

        1:
        begin
            if(req0)
            begin
                grant0 <= 1;
                last_grant <= 0;
            end
            else if(req1)
            begin
                grant1 <= 1;
                last_grant <= 1;
            end
        end

        endcase
    end
    $display("[%0t] [ARB-RR] req0=%b req1=%b grant0=%b grant1=%b",
         $time, req0, req1, grant0, grant1);
end

endmodule
