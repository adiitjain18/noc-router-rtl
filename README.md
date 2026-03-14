
### Directory Description

| Directory | Purpose |
|--------|--------|
| rtl | RTL design modules |
| tb | Testbenches for verification |
| scripts | ModelSim simulation scripts |
| sim | Simulation workspace |

rtl/
├ fifo.v
├ routing_logic.v
├ input_port.v
├ arbiter.v
├ crossbar.v
└ router.v

tb/
├ fifo_tb.v
└ router_tb.v
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


## Router Input Port

The input port represents the first stage of the router pipeline.

It combines two previously implemented modules:

- FIFO buffer
- Routing logic

Incoming packets are first stored in the FIFO.  
When packets are read from the FIFO, their destination field is extracted and sent to the routing logic to determine the correct output port.

### Packet Format

The current packet format is 8 bits:

[7:6] destination  
[5:0] payload

Example:

10_101011

destination = East  
payload = data carried by the packet

## Arbiter

The arbiter resolves conflicts when multiple input ports request the same output port.

If two packets attempt to use the same output port simultaneously, the arbiter selects one request and grants access.

### Current Implementation

A simple 2-input priority arbiter is implemented.

Inputs:
- req0
- req1

Outputs:
- grant0
- grant1

Priority rule:

req0 has higher priority than req1.

This ensures deterministic arbitration when both inputs request the same resource.

## Crossbar Switch

The crossbar switch connects router input ports to output ports.

It allows packets arriving from different input ports to be forwarded to the correct output direction.

The crossbar acts as a configurable switching fabric controlled by arbitration and routing decisions.

### Current Implementation

A simplified 2-input, 2-output crossbar is implemented.

Inputs:
- in0
- in1

Outputs:
- out0
- out1

Selection signals determine which input is connected to each output.

## Router Top-Level Module

The top-level router module integrates all previously implemented components.

Modules connected inside the router:

- Input Port
- Routing Logic
- Arbiter
- Crossbar Switch

### Router Data Flow

Incoming packets enter the router through the input port.  
Packets are buffered using the FIFO and the destination field is decoded by the routing logic.

If multiple requests target the same output port, the arbiter resolves the conflict.

Finally, the crossbar switch forwards the packet to the selected output path.

## Router Verification

A router-level testbench is implemented to verify the integration of all modules.

The testbench sends packets with different destination fields into the router and observes the output behavior.

### Packet Format

[7:6] Destination  
[5:0] Payload

Example packets used in simulation:

01_000001  
10_000010  
11_000011

Simulation verifies that packets flow correctly through the router pipeline.

## Router Architecture Evolution

The initial router implemented in this repository is a simplified single-input router used to demonstrate the basic datapath of a Network-on-Chip router.

The architecture is now being extended toward a multi-port router similar to those used in mesh NoC networks.

Next stage:

- Multi-input router
- Arbitration between competing packets
- Crossbar switching between ports

This progression gradually evolves the design into a realistic NoC router architecture.

always @(posedge clk) begin
    $display("[TIME %0t] ROUTER : data_in=%h data_out=%h",
              $time, data_in, data_out);
end

## Router Pipeline Architecture

The router datapath follows a simplified pipeline architecture similar to real NoC routers.

Pipeline stages implemented:

1. Input Buffer (FIFO)
2. Routing Computation
3. Switch Allocation
4. Switch Traversal

Pipeline registers are inserted between stages to mimic realistic router pipelines.
