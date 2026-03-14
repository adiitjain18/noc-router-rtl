if {![file exists work]} {
    vlib work
}

vmap work work

# compile RTL
vlog ../rtl/*.v

# compile testbenches
vlog ../tb/*.v

# simulate router
vsim router_tb

add wave -r *

run -all