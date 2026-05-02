# NOC Router - Extension Guide

## Overview

This guide shows how to extend the NOC Router design with additional features, ports, and capabilities.

---

## Extension 1: Multi-Port Router (4 Input Ports)

**Goal**: Extend from 1 input port to 4 input ports with arbitration

**Steps**:

1. **Duplicate input_port instances**:
   ```verilog
   input_port in_port0(...);  // Existing
   input_port in_port1(...);  // New
   input_port in_port2(...);  // New
   input_port in_port3(...);  // New
   ```

2. **Extend arbiter to 4-way**:
   ```verilog
   wire [3:0] req, grant;
   
   arbiter_4way arb(
       .clk(clk), .reset(reset),
       .req(req),      // Aggregate: req[0]=north, req[1]=east, etc.
       .grant(grant)   // grant[0..3] corresponding
   );
   ```

3. **Extend crossbar to 4×4**:
   ```verilog
   crossbar_4x4 sw(
       .in({data3, data2, data1, data0}),
       .sel(grant),
       .out(out)      // Single selected output
   );
   ```

**Complexity**: Medium
**Area Impact**: ~4× (linear scaling)
**Latency**: No change

---

## Extension 2: Increased Data Width (32-bit)

**Goal**: Support 32-bit packets instead of 8-bit

**Steps**:

1. **Update parameters/constants**:
   ```verilog
   parameter DATA_WIDTH = 32;
   parameter DEST_WIDTH = 2;
   parameter PAYLOAD_WIDTH = 30;
   ```

2. **Modify FIFO**:
   ```verilog
   reg [DATA_WIDTH-1:0] mem [0:7];
   input  [DATA_WIDTH-1:0] data_in;
   output [DATA_WIDTH-1:0] data_out;
   ```

3. **Update all signal widths**:
   ```verilog
   wire [DATA_WIDTH-1:0] fifo_out, stage1, stage2, stage3;
   wire [DATA_WIDTH-1:0] in0, in1, out0, out1;  // Crossbar
   ```

4. **Routing still works** (extracts top 2 bits):
   ```verilog
   assign dest = data_out[DATA_WIDTH-1 : DATA_WIDTH-2];
   ```

**Complexity**: Low
**Area Impact**: ~4× (linear with width)
**Latency**: No change

---

## Extension 3: Add Flow Control (Ready-Valid)

**Goal**: Implement backpressure between routers

**Steps**:

1. **Add output handshake**:
   ```verilog
   output out_valid;      // Packet ready at output
   input  out_ready;      // Downstream can accept
   
   assign out_valid = ~empty;  // Valid when FIFO has data
   assign read_en = out_ready; // Read when downstream ready
   ```

2. **Add input handshake**:
   ```verilog
   input  in_valid;       // Upstream has packet
   output in_ready;       // Router can accept
   
   assign in_ready = ~full;    // Ready when FIFO not full
   assign write_en = in_valid; // Write when upstream valid
   ```

3. **Combine with external write control**:
   ```verilog
   wire actual_write = write_en & in_ready;
   wire actual_read = read_en & out_valid;
   ```

**Complexity**: Low
**Area Impact**: ~1.1× (minimal)
**Latency**: No change

---

## Extension 4: Virtual Channels (4 VCs per port)

**Goal**: Add virtual channels for deadlock avoidance

**Steps**:

1. **Create multiple FIFOs per input port**:
   ```verilog
   // 4 VCs, 2 entries each (or 8 entries, divided 4 ways)
   fifo fifo_vc0(...);
   fifo fifo_vc1(...);
   fifo fifo_vc2(...);
   fifo fifo_vc3(...);
   ```

2. **Route packets to correct VC**:
   ```verilog
   wire [1:0] vc_id = packet[3:2];  // Bits [3:2] = VC ID
   
   mux_4to1 write_select(
       .sel(vc_id),
       .write_en(write_en),
       .vc0_we(we0), .vc1_we(we1), ...
   );
   ```

3. **Arbiter selects among VCs**:
   ```verilog
   wire [3:0] vc_req = {vc3_req, vc2_req, vc1_req, vc0_req};
   arbiter_4way vc_arb(...);
   ```

**Complexity**: High
**Area Impact**: ~4× (4 FIFOs)
**Latency**: +0-1 cycles

---

## Extension 5: Priority Queues (QoS)

**Goal**: Support quality of service with packet priorities

**Steps**:

1. **Modify packet format**:
   ```
   Old: [dest(2) | payload(6)]
   New: [dest(2) | priority(2) | payload(4)]
   ```

2. **Create priority FIFO**:
   ```verilog
   module priority_fifo(
       input [1:0] priority,
       input [1:0] dest,
       input [3:0] payload,
       // ...
   );
   
   // Internally: 4 FIFOs (one per priority level)
   // High priority FIFOs served first
   ```

3. **Update arbiter weighting**:
   ```verilog
   // Weight requests by priority
   wire [3:0] req_weighted = req & priority_mask;
   ```

**Complexity**: Medium
**Area Impact**: ~2-3×
**Latency**: No change

---

## Extension 6: Error Detection (Parity)

**Goal**: Add single-bit error detection

**Steps**:

1. **Add parity bit to packet**:
   ```verilog
   function calculate_parity(input [7:0] data);
       calculate_parity = ^data;  // XOR all bits
   endfunction
   ```

2. **Check on FIFO output**:
   ```verilog
   wire parity_error = calculate_parity(data_out) != data_out[0];
   
   always @(posedge clk) begin
       if (parity_error & ~empty)
           $display("Parity error detected!");
   end
   ```

3. **Signal errors**:
   ```verilog
   output error_flag;
   assign error_flag = parity_error & ~empty;
   ```

**Complexity**: Low
**Area Impact**: ~1.05× (parity circuits)
**Latency**: +0-1 cycles

---

## Extension 7: Clock Gating (Power Optimization)

**Goal**: Reduce power consumption during idle

**Steps**:

1. **Detect idle condition**:
   ```verilog
   wire router_idle = empty & ~write_en;
   ```

2. **Implement gating cell**:
   ```verilog
   wire gated_clk;
   
   // Integrated clock gating cell (ICG)
   icg_cell clock_gate(
       .clk(clk),
       .enable(~router_idle),
       .gated_clk(gated_clk)
   );
   ```

3. **Replace clock**:
   ```verilog
   always @(posedge gated_clk or posedge reset) begin
       // All sequential logic
   end
   ```

**Complexity**: Medium
**Area Impact**: ~1.2× (gating cells)
**Power Impact**: ~30% reduction average

---

## Extension 8: Performance Counters

**Goal**: Add debug/monitoring capabilities

**Steps**:

1. **Add counter registers**:
   ```verilog
   reg [31:0] packet_count;    // Total packets
   reg [31:0] stall_cycles;    // Cycles waiting
   reg [31:0] collision_count; // Arbitration conflicts
   ```

2. **Update counters**:
   ```verilog
   always @(posedge clk or posedge reset) begin
       if (reset) begin
           packet_count <= 0;
           stall_cycles <= 0;
           collision_count <= 0;
       end else begin
           if (valid & ready)
               packet_count <= packet_count + 1;
           if (empty & ~write_en)
               stall_cycles <= stall_cycles + 1;
           if (north & east)  // Both requesting
               collision_count <= collision_count + 1;
       end
   end
   ```

3. **Expose via register interface**:
   ```verilog
   output [31:0] status_packet_count;
   output [31:0] status_stall_count;
   output [31:0] status_collision_count;
   
   assign status_packet_count = packet_count;
   // etc.
   ```

**Complexity**: Low
**Area Impact**: ~1.15× (counters)
**Latency**: No change

---

## Recommended Extension Sequence

**Phase 1 (Core)**:
- Base router ✓

**Phase 2 (Robustness)**:
- Flow control (backpressure)
- Error detection
- Performance monitoring

**Phase 3 (Scaling)**:
- Multi-port (4×4 or 5×5)
- Virtual channels
- Increased data width

**Phase 4 (Optimization)**:
- Clock gating
- QoS/priorities
- Advanced routing

---

## Implementation Checklist

- [ ] Define extension requirements
- [ ] Design module interfaces
- [ ] Implement new modules
- [ ] Write behavioral models
- [ ] Integrate into top-level
- [ ] Create testbenches
- [ ] Verify timing (synthesis)
- [ ] Check area/power (synthesis)
- [ ] Update documentation
- [ ] Run regression tests

---

## Testing New Extensions

```verilog
// For each extension, create a testbench:

task test_extension_basic();
    // Basic functionality
endtask

task test_extension_edge_cases();
    // Boundary conditions
endtask

task test_extension_stress();
    // High activity
endtask

task test_extension_integration();
    // With other components
endtask
```

---

## Comparison: Extension Complexity

| Extension | Effort | Area | Latency | Value |
|-----------|--------|------|---------|-------|
| Flow Control | Low | 1.1× | 0 | **High** |
| Error Detect | Low | 1.05× | 0 | Medium |
| Counters | Low | 1.15× | 0 | Medium |
| Data Width | Low | 4× | 0 | Medium |
| Multi-Port | Medium | 4× | 0 | **High** |
| Priorities | Medium | 2-3× | 0 | Medium |
| Virtual Ch. | High | 4× | 0 | **High** |
| Clock Gate | Medium | 1.2× | 0 | Low |

---

## Documentation Updates

When implementing extensions, update:
1. Port definitions (MODULE_INTERFACE.md)
2. Architecture diagrams (DIAGRAMS.md)
3. Data flow descriptions (ARCHITECTURE.md)
4. Quick reference (QUICK_REFERENCE.md)
5. This guide (add new section)

