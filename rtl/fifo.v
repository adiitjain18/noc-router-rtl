module fifo (
    input  wire        clk,
    input  wire        reset,

    input  wire        write_en,
    input  wire        read_en,

    input  wire [7:0]  data_in,
    output reg  [7:0]  data_out,

    output wire        full,
    output wire        empty,
    output wire [7:0]  head_data
);

// memory array
reg [7:0] mem [0:7];

// pointers
reg [2:0] write_ptr;
reg [2:0] read_ptr;

// counter
reg [3:0] count;

// status signals
assign full  = (count == 8);
assign empty = (count == 0);

// peek current head of FIFO (for routing)
assign head_data = mem[read_ptr];

// sequential logic
always @(posedge clk or posedge reset) begin

    if (reset) begin
        write_ptr <= 0;
        read_ptr  <= 0;
        count     <= 0;
        data_out  <= 0;
    end
    else begin
    //     // The below logic caused the problem as mentioned in "fifo_tb.v". So modified the RTL Logic to fix it.
    //     // The idea is that, If write and read happen together, the count register gets two assignments in the same clock cycle, which can cause incorrect behavior.
    //     // We must explicitly handle three cases
    //      // 1. write only
    //      // 2. read only
    //      // 3. read + write together

    //         if (write_en && !full) begin
    //         mem[write_ptr] <= data_in;
    //         write_ptr <= write_ptr + 1;
    //         count <= count + 1;
    //     end

    //     // read operation
    //     if (read_en && !empty) begin
    //         data_out <= mem[read_ptr];
    //         read_ptr <= read_ptr + 1;
    //         count <= count - 1;
    //     end

    // end

        // write only
        if (write_en && !full && !(read_en && !empty)) begin
            mem[write_ptr] <= data_in;
            write_ptr <= write_ptr + 1;
            count <= count + 1;
        end

        // read only
        else if (read_en && !empty && !(write_en && !full)) begin
            data_out <= mem[read_ptr];
            read_ptr <= read_ptr + 1;
            count <= count - 1;
        end

        // simultaneous read + write
        else if (read_en && !empty && write_en && !full) begin
            mem[write_ptr] <= data_in;
            write_ptr <= write_ptr + 1;

            data_out <= mem[read_ptr];
            read_ptr <= read_ptr + 1;
            // count unchanged
        end

    end

    if(write_en && !full)
        $display("[ %0t] FIFO WRITE  : data=%h write_ptr=%0d count=%0d",
                  $time, data_in, write_ptr, count);

    if(read_en && !empty)
        // $display("[ %0t] FIFO READ   : data=%h read_ptr=%0d count=%0d",
        //           $time, data_out, read_ptr, count);

        $display("[%0t] FIFO READ : data=%h read_ptr=%0d count=%0d",
         $time, mem[read_ptr], read_ptr, count);

end
endmodule 