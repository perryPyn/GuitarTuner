# Fermer la simulation en cours si besoin
quit -sim

# Créer la bibliothèque de travail
vlib work

# Compiler les fichiers VHDL
vcom -93 registre.vhd
vcom -93 registre_tb.vhd

# Lancer la simulation sur le banc de test
vsim -voptargs=+acc work.registre_tb

# Ajouter les signaux dans la fenêtre Wave
add wave -divider {Signaux de controle}
add wave -color yellow /registre_tb/tb_clk
add wave -color orange /registre_tb/tb_rst_n
add wave -color cyan /registre_tb/tb_charg_reg

add wave -divider {Entrees}
add wave /registre_tb/tb_sens_in
add wave -radix hexadecimal /registre_tb/tb_val_in

add wave -divider {Sorties}
add wave /registre_tb/tb_sens_out
add wave -radix hexadecimal /registre_tb/tb_val_out

# Lancer la simulation jusqu'au bout
run -all

# Zoomer automatiquement pour voir toute la simulation
wave zoom full