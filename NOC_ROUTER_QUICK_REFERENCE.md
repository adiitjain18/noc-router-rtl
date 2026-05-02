# NOC Router - Quick Reference

## What Is It?

A **Network-on-Chip Router** for on-chip packet switching. Buffers incoming packets, routes them based on destination bits, and forwards them using configurable arbitration (Round-Robin or Fixed-Priority).

---

## 30-Second Overview

```
INPUT → FIFO (8x8) → PIPELINE (3 stages) → ARBITER → CROSSBAR → OUTPUT
         ↓
      ROUTING LOGIC (decodes destination)
```

- **Latency**: 5 cycles end-to-end
- **Throughput**: 1 packet/cycle
- **Packet**: 8 bits [dest(2) | payload(6)]
- **Clock**: Single domain, async reset

---

## Key Specifications

| Spec | Value |
|------|-------|
| Data Width | 8 bits |
| FIFO Depth | 8 entries (3-bit pointers) |
| Pipeline Stages | 3 registers |
| Routing Destinations | 4 (North, East, West, Local) |
| Arbiters | 2 types (RR and Fixed) |
| Latency | 5 cycles |
| Max Throughput | 1 packet/cycle |
| Area (RR) | ~700 gates |
| Power @ 100MHz | ~1 mW active |

---

## Module Breakdown

| Module | Purpose | Type | Latency |
|--------|---------|------|---------|
| **input_port** | Buffer + Route | Sync | 1 cy |
| **fifo** | 8x8 buffer | Sync | 1 cy |
| **routing_logic** | Destination decode | Comb | 0 cy |
| **pipeline** | Timing breaker | Registers | 3 cy |
| **arbiter_rr** | Round-robin priority | Sync | 1 cy |
| **arbiter_fixed** | Fixed priority | Comb | 0 cy |
| **crossbar** | 2x2 switch | Comb | 0 cy |

---

## Packet Format

```
Byte: [7:6] = dest  |  [5:0] = payload
      
Destination:
  00 = LOCAL   (stay in node)
  01 = NORTH   (go north)
  10 = EAST    (go east)
  11 = WEST    (go west)
```

---

## Arbiter Selection

**Round-Robin** (`USE_RR_ARBITER=1`):
- Fair, alternating priority
- Prevents starvation
- 1 cycle latency
- Slightly more area

**Fixed-Priority** (`USE_RR_ARBITER=0`):
- Deterministic behavior
- North always prioritized
- 0 cycle latency
- Smaller area

---

## Ports

### Main Interface

```verilog
Input:  clk, reset, write_en, read_en
        data_in[7:0]
        
Output: data_out[7:0]

Parameter: USE_RR_ARBITER = 1 (1=RR, 0=Fixed)
```

### FIFO Status (Internal)

```
full  = (count == 8)     // FIFO cannot accept
empty = (count == 0)     // FIFO is empty
```

---

## Simulation

```bash
cd noc_router/sim
vsim -do ../scripts/run.do
```

---

## Common Tasks

### Change Arbiter Type
```verilog
// In router.v
parameter USE_RR_ARBITER = 0;  // Change to 0 for fixed priority
```

### Extend to More Ports
1. Duplicate input_port + fifo for each new port
2. Extend arbiter to N-way arbitration
3. Extend crossbar to M×N switch

### Increase Data Width
Search-replace: `[7:0]` → `[31:0]` (for 32-bit)

### Add Flow Control
Add output signals: `out_valid`, `out_ready` (handshaking)

---

## Timing Path

```
FIFO read (1cy) → Stage1 (1cy) → Stage2 (1cy) → 
Stage3 (1cy) → Crossbar (0cy) → Output
= 5 cycles total latency
```

---

## Debugging Checklist

- [ ] Clock running?
- [ ] Reset asserted then deasserted?
- [ ] write_en strobed correctly?
- [ ] FIFO not full (full signal)?
- [ ] Waited 5+ cycles for output?
- [ ] Routing correct (dest bits set)?
- [ ] Simulation waveforms captured?

---

## File Locations

```
rtl/          ← Hardware modules
  router.v    ← Top-level
  input_port.v
  fifo.v
  routing_logic.v
  arbiter_rr.v, arbiter_fixed.v
  crossbar.v
  
tb/           ← Testbenches
  router_tb.v, fifo_tb.v
  
scripts/      ← Simulation
  run.do
  
docs/         ← Documentation
  NOC_ROUTER_ARCHITECTURE.md (complete design)
  NOC_ROUTER_DIAGRAMS.md (visual diagrams)
  NOC_ROUTER_MODULE_INTERFACE.md (port specs)
  NOC_ROUTER_EXTENSION_GUIDE.md (how to extend)
```

---

## Quick FAQ

**Q: How many cycles latency?**  
A: 5 cycles from input write to output visible

**Q: Can I make it faster?**  
A: Reduce pipeline stages (trade clock frequency), use fixed arbiter

**Q: Can I add more packets?**  
A: Yes, increase FIFO depth (requires wider pointers)

**Q: How do I add more output ports?**  
A: Duplicate input_port, extend arbiter and crossbar

**Q: What's the throughput?**  
A: 1 packet per cycle maximum

**Q: Can I change data width?**  
A: Yes, parametrize [7:0] → [WIDTH-1:0]

---

## Performance Metrics

- **Latency**: 5 clock cycles fixed
- **Throughput**: 1 packet/cycle = 800 Mbps @ 100 MHz, 8-bit width
- **Area**: ~550-700 gates (depends on arbiter)
- **Power**: ~1 mW @ 100 MHz, 1.2V (active)
- **Frequency**: 200+ MHz typical (tech dependent)

---

## Design Principles

1. **Modular**: Each component is independent
2. **Synchronous**: Single clock domain for simplicity
3. **Configurable**: Arbiter type selectable via parameter
4. **Testable**: Full testbenches provided
5. **Extensible**: Easy to add ports, features, width

---

**For complete details**: See NOC_ROUTER_ARCHITECTURE.md
