quit -sim
vlib work

# Compilation des fichiers VHDL
vcom sequencer.vhd
vcom sequencer_tb.vhd

# Lancement de la simulation
vsim -c work.sequencer_tb

# Ajout et organisation des signaux dans la fenêtre Wave
add wave -divider Entrees:
add wave -color cyan     /sequenceur_tb/tb_rst_n
add wave -color yellow   /sequenceur_tb/tb_freq_ref
add wave -color orange   /sequenceur_tb/tb_mesure
add wave -color orange   /sequenceur_tb/tb_etat_0

add wave -divider Etat_Interne:
add wave /sequenceur_tb/uut/current_state

add wave -divider Sorties_Commandes:
add wave -color green    /sequenceur_tb/tb_init_compt
add wave -color green    /sequenceur_tb/tb_valid_compt
add wave -color green    /sequenceur_tb/tb_sens_croiss
add wave -color green    /sequenceur_tb/tb_charg_reg

# Exécution de la simulation
run 200 ns
