# NOC Router - Module Interface Specifications

## router.v - Top Level

**Type**: Parameterized router with configurable arbitration

**Ports**:
```verilog
Input:
  clk                    // System clock (rising edge)
  reset                  // Asynchronous reset (active high)
  write_en               // Write enable to FIFO
  read_en                // Read enable (rarely used)
  data_in[7:0]           // Input packet
  
Output:
  data_out[7:0]          // Output packet

Parameter:
  USE_RR_ARBITER = 1     // 1 = Round-Robin, 0 = Fixed-Priority
```

**Sub-modules**:
- `input_port` - Input buffering and routing
- `arbiter_rr` or `arbiter_fixed` - Arbitration (selected by parameter)
- `crossbar` - Switching fabric

**Internal Signals**:
- `fifo_out[7:0]` - FIFO output to pipeline
- `north, east, west, local` - Routing signals
- `grant0, grant1` - Arbiter grants
- `stage1, stage2, stage3` - Pipeline registers
- `cross_out0, cross_out1` - Crossbar outputs

---

## input_port.v - Input Buffering

**Type**: Synchronous input port with routing

**Ports**:
```verilog
Input:
  clk, reset             // Clock and reset
  write_en, read_en      // FIFO control
  data_in[7:0]           // Input packet
  
Output:
  data_out[7:0]          // FIFO output
  north, east, west, local  // Routing (one-hot)
```

**Sub-modules**:
- `fifo` - Packet buffer
- `routing_logic` - Destination decoder

**Behavior**:
- Accepts packets when FIFO not full
- Extracts dest from packet[7:6]
- Generates routing signals (one-hot)

---

## fifo.v - Synchronous FIFO Buffer

**Type**: 8x8 synchronous FIFO with async reset

**Ports**:
```verilog
Input:
  clk, reset             // Clock and reset
  write_en, read_en      // Control signals
  data_in[7:0]           // Input data
  
Output:
  data_out[7:0]          // Output data
  full, empty            // Status signals
```

**Specs**:
- Depth: 8 entries
- Width: 8 bits
- Write pointer: 3-bit
- Read pointer: 3-bit
- Entry counter: 4-bit (range 0-8)

**Status Logic**:
```verilog
assign full  = (count == 8);
assign empty = (count == 0);
```

**Operation Modes**:
1. **Write only**: WP++, count++
2. **Read only**: RP++, count--
3. **Read+Write**: Both pointers++, count unchanged
4. **Idle**: No change

---

## routing_logic.v - Destination Decoder

**Type**: Combinational 2→4 decoder

**Ports**:
```verilog
Input:
  dest[1:0]              // Destination field
  
Output:
  north, east, west, local  // One-hot routing
```

**Truth Table**:
```
dest[1:0] | north | east | west | local | Meaning
----------|-------|------|------|-------|------------------
   00     |   0   |  0   |  0   |   1   | LOCAL
   01     |   1   |  0   |  0   |   0   | NORTH
   10     |   0   |  1   |  0   |  0   | EAST
   11     |   0   |  0   |  1   |   0   | WEST
```

**Latency**: 0 cycles (combinational)

---

## arbiter_rr.v - Round-Robin Arbiter

**Type**: Synchronous with rotating priority

**Ports**:
```verilog
Input:
  clk, reset             // Clock and reset
  req0, req1             // Requests (from routing)
  
Output:
  grant0, grant1         // Grants (one-hot)
```

**State Machine**:
```
State: last_grant (0 or 1)

State 0 (last_grant=0):
  Priority: req1 > req0
  On grant: last_grant ← 1
  
State 1 (last_grant=1):
  Priority: req0 > req1
  On grant: last_grant ← 0
```

**Output Format**: One-hot (never both 1)

**Latency**: 1 cycle (registered output)

**Fairness**: Alternating priority prevents starvation

---

## arbiter_fixed.v - Fixed-Priority Arbiter

**Type**: Combinational

**Ports**:
```verilog
Input:
  req0, req1             // Requests
  
Output:
  grant0, grant1         // Grants (one-hot)
```

**Priority Logic**:
```verilog
if (req0)
    grant0 = 1;
else if (req1)
    grant1 = 1;
else
    grant0 = grant1 = 0;
```

**Truth Table**:
```
req0 | req1 | grant0 | grant1 | Winner
-----|------|--------|--------|-------
  0  |  0   |   0    |   0    | None
  0  |  1   |   0    |   1    | req1
  1  |  0   |   1    |   0    | req0
  1  |  1   |   1    |   0    | req0
```

**Latency**: 0 cycles (combinational)

**Starvation Risk**: High if req0 continuous

---

## crossbar.v - 2×2 Crossbar Switch

**Type**: Combinational multiplexer array

**Ports**:
```verilog
Input:
  in0[7:0], in1[7:0]    // Data inputs
  sel0, sel1            // Select signals
  
Output:
  out0[7:0], out1[7:0]  // Data outputs
```

**Selection Logic**:
```verilog
if (sel0)
    out0 = in1;
else
    out0 = in0;
    
if (sel1)
    out1 = in1;
else
    out1 = in0;
```

**Configuration Examples**:
```
sel0=0, sel1=0: Both outputs from in0
sel0=0, sel1=1: Cross-connection (normal)
sel0=1, sel1=0: Cross-connection (reversed)
sel0=1, sel1=1: Both outputs from in1
```

**Latency**: 0 cycles (combinational)

---

## Signal Flow Summary

### Data Path
```
data_in[7:0] → FIFO → fifo_out[7:0] →
stage1[7:0] → stage2[7:0] → stage3[7:0] →
crossbar(in0=stage3, in1=stage3) →
out0[7:0] → data_out[7:0]
```

### Routing Path
```
packet[7:6] → routing_logic → north/east/west/local →
arbiter(req0=north, req1=east) →
grant0, grant1 → crossbar(sel0, sel1) →
output selection
```

---

## Clock and Reset

**Clock Domain**: Single synchronous clock

**Reset Behavior**:
```
reset = 1 (async):
  All pointers → 0
  All registers → 0
  All counters → 0
  FIFO emptied
  Arbiters idle
  
reset = 0 (normal):
  Logic operates normally
```

---

## Timing Paths

| Path | Latency | Components |
|------|---------|------------|
| FIFO read | 1 cy | Write→output |
| Pipeline | 3 cy | 3 register stages |
| Routing | 0 cy | Combinational |
| Arbitration | 0-1 cy | Combinational or 1 cy |
| Crossbar | 0 cy | Combinational |
| **Total** | **5 cy** | FIFO + pipeline + CB |

---

## reset_behavior.verilog

All modules use synchronous reset on rising clock edge combined with asynchronous reset:

```verilog
always @(posedge clk or posedge reset) begin
    if (reset)
        // Asynchronous reset path
        // All state → 0
    else
        // Normal sequential operation
end
```

---

## Parameter Summary

```verilog
// In router.v only
parameter USE_RR_ARBITER = 1;

// Sets whether to instantiate:
// - arbiter_rr (if 1)
// - arbiter_fixed (if 0)

// No other parameters (widths/depths are hardcoded)
```

---

## Interface Matrix

| Signal | Router | Input_Port | FIFO | Arbiter | Crossbar |
|--------|--------|------------|------|---------|----------|
| clk | I | I | I | I | — |
| reset | I | I | I | I | — |
| data_in | I | I | — | — | — |
| write_en | I | I | — | — | — |
| data_out | O | O | O | — | O |
| full | — | — | O | — | — |
| empty | — | — | O | — | — |
| north | — | O | — | I | — |
| east | — | O | — | I | — |
| grant0 | — | — | — | O | I |
| grant1 | — | — | — | O | I |

I = Input, O = Output, — = Not connected

