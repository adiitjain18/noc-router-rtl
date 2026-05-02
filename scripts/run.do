# create library
if {![file exists work]} {
    vlib work
}

vmap work work

# compile ALL RTL
# vlog ../rtl/*.v

vlog ../rtl/fifo.v
vlog ../rtl/routing_logic.v
vlog ../rtl/input_port.v
vlog ../rtl/arbiter_fixed.v
vlog ../rtl/arbiter_rr.v
vlog ../rtl/crossbar.v
vlog ../rtl/router.v
vlog ../rtl/router_2port.v

# compile testbenches
vlog ../tb/*.v

# simulate
vsim router_tb -gUSE_RR_ARBITER=1

delete wave *
add wave -r *

run -all