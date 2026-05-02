module routing_logic(
    input  [1:0] dest,
    output reg north,
    output reg east,
    output reg west,
    output reg local_out
);

always @(*) begin

    north = 0;
    east  = 0;
    west  = 0;
    local_out = 0;

    case(dest)

        2'b00: begin
            local_out = 1;
            $display("[%0t] ROUTING : dest=%b -> LOCAL", $time, dest);
        end

        2'b01: begin
            north = 1;
            $display("[%0t] ROUTING : dest=%b -> NORTH", $time, dest);
        end

        2'b10: begin
            east = 1;
            $display("[%0t] ROUTING : dest=%b -> EAST", $time, dest);
        end

        2'b11: begin
            west = 1;
            $display("[%0t] ROUTING : dest=%b -> WEST", $time, dest);
        end

    endcase

end

endmodule