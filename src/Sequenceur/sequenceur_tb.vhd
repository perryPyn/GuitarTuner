library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sequenceur_tb is
end entity sequenceur_tb;

architecture tb of sequenceur_tb is
    -- Signaux de test interconnectés au composant
    signal tb_freq_ref    : std_logic := '0';
    signal tb_rst_n       : std_logic := '0';
    signal tb_mesure      : std_logic := '0';
    signal tb_etat_0      : std_logic := '0';
    
    signal tb_init_compt  : std_logic;
    signal tb_valid_compt : std_logic;
    signal tb_sens_croiss : std_logic;
    signal tb_charg_reg   : std_logic;

    -- Période de l'horloge de référence (10 ns -> 100 MHz)
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiation du Séquenceur (UUT : Unit Under Test)
    uut: entity work.sequencer 
        port map (
            i_freq_ref    => tb_freq_ref,
            i_rst_n       => tb_rst_n,
            i_mesure      => tb_mesure,
            i_etat_0      => tb_etat_0,
            o_init_compt  => tb_init_compt,
            o_valid_compt => tb_valid_compt,
            o_sens_croiss => tb_sens_croiss,
            o_charg_reg   => tb_charg_reg
        );

    -- Génération de l'horloge
    clk_process : process
    begin
        tb_freq_ref <= '0';
        wait for CLK_PERIOD / 2;
        tb_freq_ref <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Séquence de test (Stimuli)
    stim_process : process
    begin
        -- 1. Reset initial au démarrage
        tb_rst_n  <= '0';
        tb_mesure <= '0';
        tb_etat_0 <= '0';
        wait for 25 ns;
        
        -- 2. On relève le reset
        tb_rst_n <= '1';
        wait for 20 ns;

        -- 3. Début de la fenêtre de mesure (-> état DECOMPTAGE)
        tb_mesure <= '1';
        wait for 40 ns;

        -- 4. Le compteur atteint 0 (-> état COMPTAGE)
        tb_etat_0 <= '1';
        wait for 10 ns;
        tb_etat_0 <= '0';
        wait for 40 ns;

        -- 5. Fin de la mesure (-> état SAUVEGARDE puis retour ATTENTE)
        tb_mesure <= '0';
        wait for 40 ns;

        -- Fin de la simulation
        wait;
    end process;

end architecture tb;