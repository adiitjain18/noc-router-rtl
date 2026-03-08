if {![file exists work]} {
    vlib work
}

vmap work work

# Compile all RTL files
vlog ../rtl/*.v

# Compile all testbenches
vlog ../tb/*.v

# Simulate
vsim fifo_tb

# Waveform setup
add wave -r *

# Run simulation
run -all