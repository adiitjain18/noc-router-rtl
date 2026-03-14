`timescale 1ns/1ps

module router_tb;

reg clk;
reg reset;

reg write_en;
reg read_en;

reg [7:0] data_in;
wire [7:0] data_out;

reg [7:0] expected [0:7];
integer read_ptr;
// instantiate router
router #(.USE_RR_ARBITER(1)) uut(

    .clk(clk),
    .reset(reset),

    .write_en(write_en),
    .read_en(read_en),

    .data_in(data_in),
    .data_out(data_out)

);


// clock generation
always #5 clk = ~clk;
initial begin
    $monitor("[ %0t] TB : data_in=%h write=%b read=%b data_out=%h",
              $time, data_in, write_en, read_en, data_out);
end

always @(posedge clk)
begin
    if(read_en)
    begin
        if(data_out !== expected[read_ptr])
        begin
            $display("[%0t] TEST FAIL: expected=%h got=%h",
                     $time, expected[read_ptr], data_out);
            $fatal;
        end
        else
        begin
            $display("[%0t] TEST PASS: packet=%h",
                     $time, data_out);
        end

        read_ptr = read_ptr + 1;
    end
end


initial
begin
    #500;
    $display("-----------------------------------");
    $display("Router Simulation Completed");
    $display("All packets verified");
    $display("-----------------------------------");
end

initial begin

    clk = 0;
    reset = 1;
    write_en = 0;
    read_en = 0;
    data_in = 0;

    expected[0] = 8'b01_000001;
    expected[1] = 8'b10_000010;
    expected[2] = 8'b11_000011;

    read_ptr = 0;

    // release reset
    #15 reset = 0;

    // send packets
    @(posedge clk) write_en = 1; data_in = 8'b01_000001;
    @(posedge clk) data_in = 8'b10_000010;
    @(posedge clk) data_in = 8'b11_000011;
    @(posedge clk) write_en = 0;

    // start reading
    @(posedge clk) read_en = 1;
    repeat(5) @(posedge clk);

    read_en = 0;

    #20 $finish;

end

endmodule