quit -sim

vlib work

vcom -2008 divider.vhd
vcom -2008 divider_tb.vhd

vsim -c work.divider_tb

# INPUTS
add wave -divider Inputs:
add wave -color yellow uut/i_reset_n
add wave -color red uut/i_freqVar


# OUTPUTS
add wave -divider Outputs:
add wave -color green uut/o_measure

run -all

