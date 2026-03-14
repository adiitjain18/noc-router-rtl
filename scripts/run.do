# create library
if {![file exists work]} {
    vlib work
}

vmap work work

# compile ALL RTL
vlog ../rtl/*.v

# compile testbenches
vlog ../tb/*.v

# simulate
vsim router_tb -gUSE_RR_ARBITER=1

delete wave *
add wave -r *

run -all