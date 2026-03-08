
### Directory Description

| Directory | Purpose |
|--------|--------|
| rtl | RTL design modules |
| tb | Testbenches for verification |
| scripts | ModelSim simulation scripts |
| sim | Simulation workspace |

---

# Router Architecture Overview

A typical **Network-on-Chip router** consists of several hardware blocks:

```

Incoming Flit
│
▼
Input Buffer (FIFO)
│
▼
Routing Logic
│
▼
Arbiter
│
▼
Crossbar Switch
│
▼
Output Ports

```

Each block will be implemented step-by-step.

---

# Implemented Module

## FIFO Buffer

The FIFO is the **first building block of the router input port**.

It stores incoming packets temporarily before routing decisions are made.

### Features

- Synchronous FIFO
- 8-bit data width
- Depth = 8 entries
- Separate read and write control
- Full and empty status signals

### FIFO Interface

```verilog
module fifo (
    input clk,
    input reset,
    input write_en,
    input read_en,
    input [7:0] data_in,
    output [7:0] data_out,
    output full,
    output empty
);
```
        write_en
           │
           ▼
      Write Pointer
           │
           ▼
       +--------+
       | Memory |
       +--------+
           ▲
           │
       Read Pointer
           │
           ▼
        data_out


## Routing Logic

The routing logic determines which output port a packet should use based on its destination field.

A simplified destination encoding is used:

00 → Local  
01 → North  
10 → East  
11 → West  

The routing module decodes the destination field and generates a one-hot output indicating the selected port.

Example:

dest = 10 → East output activated.