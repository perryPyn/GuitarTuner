quit -sim

vlib work

vcom clk-divider.vhd
vcom counter.vhd
vcom divider.vhd
vcom registre.vhd
vcom sequencer.vhd
vcom decoder.vhd
vcom monoFrequency.vhd
vcom monoFrequency_tb.vhd

vsim -c work.monoFrequency_tb

# CLOCK
add wave -divider Clock:
add wave -color green uut/i_rst_n
add wave -color green uut/i_clk
add wave -color green uut/s_freq_ref

# INPUTS
add wave -divider Inputs:
add wave -color yellow uut/i_freq_var

# DATA
add wave -divider Data:
add wave -color red uut/o_data
add wave -color red uut/o_sens_crois

# DIVISER
add wave -divider Diviser:
add wave -color orange uut/u_divider/s_isDone
add wave -color orange uut/u_divider/o_measure

# COUNTER
add wave -divider Counter:
# add wave -color yellow uut/u_counter/i_valid_cnt
# add wave -color yellow uut/u_counter/i_sens_crois
add wave -color red uut/u_counter/s_cnt
add wave -color red uut/u_counter/o_data
add wave -color red uut/u_counter/o_etat_0

# SEQUENCER
add wave -divider Sequencer:
# add wave -color yellow   uut/u_sequencer/i_mesure
# add wave -color yellow   uut/u_sequencer/i_etat_0
add wave -color orange    uut/u_sequencer/o_init_compt
add wave -color orange    uut/u_sequencer/o_valid_compt
add wave -color orange    uut/u_sequencer/o_sens_crois
add wave -color orange    uut/u_sequencer/o_charg_reg
add wave -color cyan   uut/u_sequencer/current_state

# REGISTER
add wave -divider Register:
# add wave -color yellow uut/u_register/i_charg_reg
# add wave -color yellow uut/u_register/i_sens_crois
# add wave -color yellow uut/u_register/i_data
add wave -color orange uut/u_register/o_sens_crois
add wave -color red uut/u_register/o_data

# DECODER
# add wave -divider Decoder:
add wave -color yellow uut/u_decoder/i_data
add wave -color red uut/u_decoder/o_data

run -all

wave zoom full
