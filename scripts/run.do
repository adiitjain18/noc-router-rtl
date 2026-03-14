# create library if needed
if {![file exists work]} {
    vlib work
}

vmap work work

# compile RTL
vlog ../rtl/*.v

# compile testbenches
vlog ../tb/*.v

# start simulation
vsim router_tb

# remove old wave signals
delete wave *

# add signals once
add wave -r *

# run simulation
run -all