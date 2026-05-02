# NOC Router - Visual Architecture Diagrams

## 1. Module Hierarchy

```mermaid
graph TD
    A["<b>router</b><br/>Top Level"] --> B["<b>input_port</b>"]
    A --> C{Arbiter<br/>Selection}
    C -->|USE_RR=1| D["<b>arbiter_rr</b>"]
    C -->|USE_RR=0| E["<b>arbiter_fixed</b>"]
    A --> F["<b>crossbar</b>"]
    
    B --> G["<b>fifo</b><br/>8x8 Buffer"]
    B --> H["<b>routing_logic</b>"]
    
    style A fill:#4CAF50,stroke:#2E7D32,color:#fff,stroke-width:3px
    style B fill:#2196F3,stroke:#1565C0,color:#fff
    style D fill:#FF9800,stroke:#E65100,color:#fff
    style E fill:#FF9800,stroke:#E65100,color:#fff
    style F fill:#9C27B0,stroke:#6A1B9A,color:#fff
    style G fill:#00BCD4,stroke:#00838F,color:#fff
    style H fill:#00BCD4,stroke:#00838F,color:#fff
```

---

## 2. Data Path Flow

```mermaid
graph LR
    A["<b>data_in[7:0]</b><br/>write_en"] --> B["<b>FIFO</b><br/>8x8"]
    B -->|fifo_out| C["<b>Pipeline</b><br/>Stage 1"]
    C -->|stage1| D["<b>Pipeline</b><br/>Stage 2"]
    D -->|stage2| E["<b>Pipeline</b><br/>Stage 3"]
    E -->|stage3| F["<b>Crossbar</b><br/>2x2 Mux"]
    F -->|out0| G["<b>data_out[7:0]</b>"]
    
    style B fill:#E3F2FD
    style C fill:#E8F5E9
    style D fill:#E8F5E9
    style E fill:#E8F5E9
    style F fill:#F3E5F5
    style G fill:#C8E6C9
```

---

## 3. Control/Routing Path

```mermaid
graph LR
    A["<b>FIFO Output</b><br/>packet[7:0]"] --> B["<b>Extract dest</b><br/>packet[7:6]"]
    B -->|2-bit| C["<b>Routing Logic</b><br/>2→4 Decoder"]
    C -->|one-hot| D["4 Routing Signals"]
    D -->|north=req0| E["<b>Arbiter</b>"]
    D -->|east=req1| E
    E -->|grant0,grant1| F["<b>Crossbar</b><br/>Select Signals"]
    F -->|sel0,sel1| G["<b>Data Routed</b><br/>to Output"]
    
    style B fill:#FFF3E0
    style C fill:#FFF3E0
    style E fill:#F3E5F5
    style G fill:#C8E6C9
```

---

## 4. Routing Logic Truth Table

```mermaid
graph TD
    A["<b>dest[1:0]</b>"]
    A -->|2'b00| B["<b>LOCAL</b><br/>Stays in node"]
    A -->|2'b01| C["<b>NORTH</b><br/>North neighbor"]
    A -->|2'b10| D["<b>EAST</b><br/>East neighbor"]
    A -->|2'b11| E["<b>WEST</b><br/>West neighbor"]
    
    B -.->|0 cycles| F["Output"]
    C -.->|0 cycles| F
    D -.->|0 cycles| F
    E -.->|0 cycles| F
    
    style A fill:#FFF9C4,stroke:#F57F17,stroke-width:2px
    style B fill:#FFCDD2
    style C fill:#BBDEFB
    style D fill:#C8E6C9
    style E fill:#FFE0B2
    style F fill:#E0E0E0
```

---

## 5. Arbiter Comparison

```mermaid
graph TD
    subgraph RR["<b>Round-Robin Arbiter</b>"]
        A["State = 0<br/>last_grant=0"]
        B["Priority:<br/>req1 > req0"]
        C["On grant:<br/>→ State 1"]
        
        D["State = 1<br/>last_grant=1"]
        E["Priority:<br/>req0 > req1"]
        F["On grant:<br/>→ State 0"]
        
        A --> B --> C
        D --> E --> F
        C -->|next cycle| D
        F -->|next cycle| A
    end
    
    subgraph Fixed["<b>Fixed-Priority Arbiter</b>"]
        G["Always<br/>Priority: req0"]
        H["if req0: grant0<br/>else if req1: grant1"]
        I["Fully<br/>Deterministic"]
        
        G --> H --> I
    end
    
    style A fill:#FFE082
    style D fill:#FFE082
    style G fill:#B39DDB
```

---

## 6. FIFO Internal Structure

```mermaid
graph TD
    A["<b>Write Input</b><br/>data_in[7:0]"] --> B["<b>Memory Array</b><br/>reg[7:0] mem[0:7]"]
    C["<b>Write Pointer</b><br/>3-bit WP"] -->|mem[WP]| B
    D["<b>Read Pointer</b><br/>3-bit RP"] -->|mem[RP]| B
    B --> E["<b>Read Output</b><br/>data_out[7:0]"]
    
    F["<b>Entry Counter</b><br/>4-bit count"] -->|logic| G["full = count==8"]
    F -->|logic| H["empty = count==0"]
    
    style B fill:#E3F2FD,stroke:#1976D2,stroke-width:2px
    style C fill:#FFF3E0
    style D fill:#FFF3E0
    style F fill:#E8F5E9
    style G fill:#FFCDD2
    style H fill:#FFCDD2
```

---

## 7. Pipeline Stages Timeline

```mermaid
graph LR
    A["Cycle 0<br/>FIFO In"] -->|1 cy| B["Cycle 1<br/>Stage1"]
    B -->|1 cy| C["Cycle 2<br/>Stage2"]
    C -->|1 cy| D["Cycle 3<br/>Stage3"]
    D -->|0 cy| E["Cycle 3<br/>Crossbar"]
    E -->|0 cy| F["Cycle 4<br/>Output"]
    
    G["<b>Total: 4-5 cycles</b>"] -.-> A
    G -.-> F
    
    style A fill:#FFCDD2
    style B fill:#E3F2FD
    style C fill:#E3F2FD
    style D fill:#E3F2FD
    style E fill:#F3E5F5
    style F fill:#C8E6C9
    style G fill:#FFF9C4,stroke:#F57F17,stroke-width:2px
```

---

## 8. Crossbar Switch Function

```mermaid
graph TD
    A["<b>Input 0</b><br/>in0[7:0]"] --> C["Mux0<br/>sel0"]
    B["<b>Input 1</b><br/>in1[7:0]"] --> C
    C --> D["<b>Output 0</b><br/>out0[7:0]"]
    
    A --> E["Mux1<br/>sel1"]
    B --> E
    E --> F["<b>Output 1</b><br/>out1[7:0]"]
    
    G["Logic:<br/>if sel: out=in1<br/>else: out=in0"]
    
    style A fill:#E3F2FD
    style B fill:#E3F2FD
    style C fill:#F3E5F5,stroke-width:2px
    style E fill:#F3E5F5,stroke-width:2px
    style D fill:#C8E6C9
    style F fill:#C8E6C9
    style G fill:#FFF9C4
```

---

## 9. Packet Format Breakdown

```mermaid
graph TD
    A["<b>8-bit Packet</b><br/>bits [7:0]"]
    A --> B["Bits [7:6]<br/><b>DESTINATION</b>"]
    A --> C["Bits [5:0]<br/><b>PAYLOAD</b>"]
    
    B -->|2'b00| D["LOCAL"]
    B -->|2'b01| E["NORTH"]
    B -->|2'b10| F["EAST"]
    B -->|2'b11| G["WEST"]
    
    C -->|6 bits| H["User Data"]
    
    style A fill:#FFF9C4,stroke-width:2px
    style B fill:#FFCDD2
    style C fill:#C8E6C9
```

---

## 10. Complete Data Flow Sequence

```mermaid
sequenceDiagram
    participant Input
    participant FIFO
    participant Pipeline
    participant Arbiter
    participant Crossbar
    participant Output
    
    Input->>FIFO: Write packet (0xA5)
    FIFO->>Pipeline: fifo_out[1]
    Pipeline->>Pipeline: stage1[2] → stage2[3] → stage3[4]
    Arbiter->>Arbiter: Evaluate requests[2-4]
    Pipeline->>Crossbar: stage3 data[4]
    Arbiter->>Crossbar: grant signals[4]
    Crossbar->>Output: Routed data[4-5]
    Output->>Output: data_out visible[5]
    
    Note over Input,Output: Total Latency: 5 cycles
```

---

## 11. Clock and Reset Timing

```mermaid
graph LR
    A["clk"] -->|rising edge| B["Sequential Logic<br/>Updates"]
    C["reset"] -->|async| D["All State → 0"]
    
    B --> E["Pointers increment"]
    B --> F["Registers load"]
    B --> G["Counters update"]
    
    D --> E
    D --> F
    D --> G
    
    style A fill:#FFE082
    style C fill:#FFCDD2
    style B fill:#C8E6C9
    style D fill:#FFCDD2
```

---

## 12. Area and Latency Trade-off

```mermaid
graph LR
    A["Pipeline Depth<br/>1 stage"] -->|Lowest Latency| B["2 cycles"]
    A -->|Low Area| C["Minimal gates"]
    
    D["Pipeline Depth<br/>3 stages"] -->|Medium Latency| E["5 cycles"]
    D -->|Medium Area| F["Standard gates"]
    
    G["Pipeline Depth<br/>5+ stages"] -->|Higher Latency| H["7+ cycles"]
    G -->|Higher Area| I["More gates"]
    
    style A fill:#E3F2FD
    style D fill:#FFF3E0,stroke-width:2px
    style G fill:#FFCDD2
```

---

## Key Metrics Summary

| Metric | Value | Notes |
|--------|-------|-------|
| **Data Width** | 8 bits | Fixed |
| **FIFO Depth** | 8 entries | 3-bit pointers |
| **Pipeline Stages** | 3 | Configurable |
| **Latency** | 5 cycles | FIFO+3 stages+CB |
| **Throughput** | 1 pkt/cycle | 800 Mbps @ 100 MHz |
| **Area (RR)** | ~700 gates | Approximate |
| **Area (Fixed)** | ~550 gates | Approximate |
| **Arbiters** | 2 types | Both provided |

