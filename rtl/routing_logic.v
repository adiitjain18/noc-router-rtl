module routing_logic(

    input  [1:0] dest,

    output reg north,
    output reg east,
    output reg west,
    output reg local

);

always @(*) begin

    north = 0;
    east  = 0;
    west  = 0;
    local = 0;

    case(dest)

        2'b00: local = 1;
        2'b01: north = 1;
        2'b10: east  = 1;
        2'b11: west  = 1;

    endcase

end

endmodule