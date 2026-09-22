quit -sim

vlib work

vcom counter.vhd
vcom counter_tb.vhd

vsim -c work.counter_tb
# CLOCK
add wave -divider Clock:
add wave -color green uut/i_freq_ref
add wave -color green uut/i_rst_n

# INPUTS
add wave -divider Inputs:
add wave -color yellow uut/i_init_cnt
add wave -color yellow uut/i_valid_cnt
add wave -color yellow uut/i_sens_crois

# COUNTER
add wave -divider Counter:
add wave -color red uut/r_cnt

# DATA
add wave -divider Data:
add wave -color cyan uut/o_data
add wave -color cyan uut/o_etat_0

run -all
