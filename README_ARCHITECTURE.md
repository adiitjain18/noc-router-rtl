# NOC Router Documentation - Master Index

## 📖 Overview

Complete architectural documentation for a **Network-on-Chip (NOC) Router** - a packet-switching fabric for on-chip interconnection networks.

**Design Type**: Synchronous, single-clock domain router  
**Data Width**: 8 bits per packet  
**Architecture**: FIFO → Pipeline → Arbiter → Crossbar  
**Latency**: 5 cycles  
**Throughput**: 1 packet/cycle  
**Configuration**: Parametrized arbitration (RR or Fixed-Priority)

---

## 📚 Documentation Files

### 1. NOC_ROUTER_QUICK_REFERENCE.md ⭐ **START HERE**

**Best for**: Quick lookups, 30-second overview, fast answers

Contains:
- 30-second architecture summary
- Key specifications table
- Packet format
- Arbiter comparison
- Ports and signals
- Simulation commands
- Common FAQs
- Performance metrics
- Debugging checklist

**Reading time**: 10-15 minutes  
**Use case**: New users, quick reference during development

---

### 2. NOC_ROUTER_ARCHITECTURE.md **COMPLETE DESIGN**

**Best for**: Comprehensive understanding of the system

Contains:
- System architecture overview
- Component descriptions (Input Port, FIFO, Routing, Arbiter, Crossbar, Pipeline)
- Packet format specification
- Cycle-by-cycle data flow example
- Control flow analysis
- Signal connectivity diagram
- Timing characteristics
- Design variants (router vs router_2port)
- Module hierarchy
- Design decisions explained
- Performance metrics (latency, throughput, area, power)
- Verification approach
- Extension points

**Reading time**: 45-60 minutes  
**Use case**: System-level understanding, design reviews

---

### 3. NOC_ROUTER_DIAGRAMS.md **VISUAL REFERENCE**

**Best for**: Visual learners, understanding data/control paths

Contains 12 Mermaid diagrams:
1. Module hierarchy tree
2. Data path flow
3. Control/routing path
4. Routing logic truth table
5. Arbiter comparison (RR vs Fixed)
6. FIFO internal structure
7. Pipeline stages timeline
8. Crossbar switch function
9. Packet format breakdown
10. Complete data flow sequence
11. Clock and reset timing
12. Area vs latency trade-off

**Reading time**: 20-30 minutes  
**Use case**: Presentations, quick visual understanding, printing

---

### 4. NOC_ROUTER_MODULE_INTERFACE.md **PORT SPECIFICATIONS**

**Best for**: Implementation details, exact port definitions

Contains specifications for:
- router.v (top-level)
- input_port.v
- fifo.v
- routing_logic.v
- arbiter_rr.v
- arbiter_fixed.v
- crossbar.v

For each module:
- Port definitions with directions
- Bit widths and signal meanings
- Internal signal descriptions
- Truth tables and operation modes
- Behavioral descriptions
- Timing paths
- Reset behavior
- Parameter definitions

**Reading time**: 45-60 minutes  
**Use case**: RTL coding, debugging, integration

---

### 5. NOC_ROUTER_EXTENSION_GUIDE.md **CUSTOMIZATION**

**Best for**: Extending the design with new features

Contains 8 extension guides with complete steps:
1. Multi-port router (4 input ports)
2. Increased data width (32-bit)
3. Flow control (Ready-Valid handshaking)
4. Virtual channels (4 VCs per port)
5. Priority queues (QoS)
6. Error detection (parity)
7. Clock gating (power optimization)
8. Performance counters (monitoring)

For each extension:
- Goal statement
- Implementation steps with code snippets
- Complexity assessment
- Area impact
- Latency impact
- Use cases

Plus:
- Recommended extension sequence
- Implementation checklist
- Testing recommendations
- Complexity comparison table

**Reading time**: 30-40 minutes  
**Use case**: Design modifications, feature additions

---

## 🎯 Quick Navigation Guide

### "I'm new - where do I start?"
1. Read: NOC_ROUTER_QUICK_REFERENCE.md (10 min)
2. Study: NOC_ROUTER_DIAGRAMS.md (20 min)
3. Deep dive: NOC_ROUTER_ARCHITECTURE.md (60 min)

### "I need to understand the architecture"
- Start: NOC_ROUTER_QUICK_REFERENCE.md (overview)
- Then: NOC_ROUTER_ARCHITECTURE.md (details)
- Visual: NOC_ROUTER_DIAGRAMS.md (diagrams)

### "I need exact port definitions"
- Reference: NOC_ROUTER_MODULE_INTERFACE.md
- For context: NOC_ROUTER_ARCHITECTURE.md relevant sections

### "I want to add a feature/extend the design"
- Reference: NOC_ROUTER_EXTENSION_GUIDE.md
- For context: NOC_ROUTER_ARCHITECTURE.md module descriptions
- For ports: NOC_ROUTER_MODULE_INTERFACE.md

### "I need to debug something"
- Quick answers: NOC_ROUTER_QUICK_REFERENCE.md (debugging section)
- Details: NOC_ROUTER_MODULE_INTERFACE.md (module specs)
- Timing: NOC_ROUTER_DIAGRAMS.md (timing diagrams)

### "I want to understand the data flow"
- Visual: NOC_ROUTER_DIAGRAMS.md (data path + sequence diagrams)
- Example: NOC_ROUTER_ARCHITECTURE.md (cycle-by-cycle example)
- Details: NOC_ROUTER_QUICK_REFERENCE.md (timing path)

---

## 📋 Document Comparison Matrix

| Aspect | Quick Ref | Architecture | Diagrams | Interface | Extension |
|--------|-----------|--------------|----------|-----------|-----------|
| **Overview** | ✓✓ | ✓✓✓ | ✓✓ | — | — |
| **Diagrams** | — | ✓ | ✓✓✓ | — | — |
| **Port specs** | ✓ | — | — | ✓✓✓ | — |
| **Data flow** | ✓ | ✓✓ | ✓✓✓ | — | — |
| **Timing** | ✓ | ✓ | ✓✓ | ✓ | — |
| **How to extend** | — | — | — | — | ✓✓✓ |
| **FAQs** | ✓✓ | — | — | — | — |
| **Code examples** | — | ✓ | — | ✓ | ✓✓ |
| **Conciseness** | ✓✓✓ | — | ✓✓ | ✓ | ✓ |

---

## 🔍 By Topic Index

| Topic | Best Document | Section |
|-------|--------|---------|
| **Architecture Overview** | Architecture.md | System Architecture |
| **Components** | Architecture.md | Component Overview |
| **Packet Format** | Quick Reference.md | Packet Format |
| **Data Flow** | Diagrams.md | Data Path Flow, Sequence |
| **Control Flow** | Diagrams.md | Control/Routing Path |
| **FIFO Details** | Architecture.md + Interface.md | FIFO Sections |
| **Routing Logic** | Diagrams.md + Interface.md | Routing sections |
| **Arbiter (RR)** | Diagrams.md + Interface.md | Arbiter sections |
| **Arbiter (Fixed)** | Diagrams.md + Interface.md | Arbiter sections |
| **Crossbar** | Diagrams.md + Interface.md | Crossbar sections |
| **Pipeline** | Diagrams.md + Architecture.md | Pipeline sections |
| **Timing** | Diagrams.md + Quick Reference.md | Timing sections |
| **Simulation** | Quick Reference.md | Simulation section |
| **Extensions** | Extension Guide.md | All sections |
| **Error Debugging** | Quick Reference.md | Debugging Checklist |

---

## 📊 Design Summary

```
INPUT PACKET [dest(2) | payload(6)]
    ↓
FIFO Buffer (8x8, 1 cycle latency)
    ↓
Extract destination bits
    ↓
Routing Logic (combinational)
    ↓
Generate routing request (one-hot)
    ↓
Pipeline 3 stages (3 cycles latency)
    ↓
Arbiter selects winner (RR or Fixed)
    ↓
Crossbar routes to output (combinational)
    ↓
OUTPUT PACKET

Total: 5 cycles latency, 1 packet/cycle throughput
```

---

## ✅ Checklist: Which Document to Read?

- [ ] **Need quick answer?** → Quick Reference
- [ ] **Need complete overview?** → Architecture
- [ ] **Need visual understanding?** → Diagrams
- [ ] **Coding/RTL implementation?** → Interface
- [ ] **Adding features?** → Extension Guide
- [ ] **Learning the system?** → Read all in order
- [ ] **Debugging issue?** → Quick Reference (Debugging) + Interface
- [ ] **Presentation/sharing?** → Diagrams + Quick Reference
- [ ] **Deep technical review?** → Architecture + Interface

---

## 📈 Reading Paths by Time Available

### 5 Minutes
- NOC_ROUTER_QUICK_REFERENCE.md (first 2 sections)

### 15 Minutes
- NOC_ROUTER_QUICK_REFERENCE.md (complete)

### 30 Minutes
- NOC_ROUTER_QUICK_REFERENCE.md (15 min)
- NOC_ROUTER_DIAGRAMS.md (15 min, key diagrams)

### 1 Hour
- NOC_ROUTER_QUICK_REFERENCE.md (15 min)
- NOC_ROUTER_ARCHITECTURE.md (30 min)
- NOC_ROUTER_DIAGRAMS.md (15 min)

### 2-3 Hours
- All documents in order

---

## 🏗️ File Structure

```
noc_router/
├── rtl/                              ← RTL Design
│   ├── router.v                      ← Top-level
│   ├── input_port.v
│   ├── fifo.v
│   ├── routing_logic.v
│   ├── arbiter_rr.v, arbiter_fixed.v
│   └── crossbar.v
├── tb/                               ← Testbenches
│   └── router_tb.v, fifo_tb.v
├── scripts/                          ← Simulation
│   └── run.do
├── sim/                              ← Simulation workspace
│   ├── modelsim.ini
│   ├── transcript
│   ├── vsim.wlf
│   └── work/
└── 📖 Documentation/                 ← YOU ARE HERE
    ├── NOC_ROUTER_ARCHITECTURE.md
    ├── NOC_ROUTER_DIAGRAMS.md
    ├── NOC_ROUTER_MODULE_INTERFACE.md
    ├── NOC_ROUTER_EXTENSION_GUIDE.md
    ├── NOC_ROUTER_QUICK_REFERENCE.md
    └── README_ARCHITECTURE.md (this file)
```

---

## 🔗 Cross-References

Each document includes references to related sections:
- Quick Reference → Architecture (for details)
- Architecture → Diagrams (for visual)
- Diagrams → Interface (for specifications)
- Interface → Architecture (for context)
- Extension → All docs (for details)

---

## 💡 Tips for Using This Documentation

1. **Print-friendly**: All documents work well on paper (15-20 pages total)
2. **Searchable**: Use Ctrl+F to search within documents
3. **Standalone**: Each document works independently
4. **Complementary**: Read multiple for complete understanding
5. **Shareable**: Send individual documents as needed
6. **Updateable**: Modify for your extensions/variants

---

## 🎓 Learning Objectives

After reading this documentation, you should understand:

✓ How the NOC Router works (data flow)  
✓ What each component does (FIFO, Routing, Arbiter, Crossbar)  
✓ How to use it (ports, signals, simulation)  
✓ Performance characteristics (latency, throughput)  
✓ How to extend it (new ports, features, width)  
✓ How to debug issues (signal flow, timing)  

---

## 📞 Quick Reference Card

```
Architecture: INPUT → FIFO → PIPELINE(3) → ARBITER → CROSSBAR → OUTPUT
Latency: 5 cycles
Throughput: 1 packet/cycle
Packet: [dest(2 bits) | payload(6 bits)]
Config: USE_RR_ARBITER = 1 (or 0)
Simulation: cd sim && vsim -do ../scripts/run.do
```

---

## 🚀 Next Steps

1. **Start**: Open NOC_ROUTER_QUICK_REFERENCE.md
2. **Learn**: Study NOC_ROUTER_ARCHITECTURE.md
3. **Visualize**: Review NOC_ROUTER_DIAGRAMS.md
4. **Implement**: Reference NOC_ROUTER_MODULE_INTERFACE.md
5. **Extend**: Follow NOC_ROUTER_EXTENSION_GUIDE.md

---

**Documentation Status**: Complete & Ready  
**Last Updated**: May 2, 2026  
**Total Pages**: ~170 pages  
**Total Diagrams**: 12 Mermaid diagrams  

