library ieee;
use ieee.std_logic_1164.all;

entity registre_tb is
end entity registre_tb;

architecture tb of registre_tb is
    -- Signaux de test
    signal tb_clk      : std_logic := '0';
    signal tb_rst_n    : std_logic := '0';
    signal tb_charg_reg: std_logic := '0';
    signal tb_sens_in  : std_logic := '0';
    signal tb_val_in   : std_logic_vector(3 downto 0) := "0000";
    signal tb_sens_out : std_logic;
    signal tb_val_out  : std_logic_vector(3 downto 0);

    -- Constante pour la période d'horloge
    constant clk_period : time := 10 ns;

begin
    -- Instanciation du composant sous test (UUT)
    uut: entity work.registre
        port map (
            clk       => tb_clk,
            rst_n     => tb_rst_n,
            charg_reg => tb_charg_reg,
            sens_in   => tb_sens_in,
            val_in    => tb_val_in,
            sens_out  => tb_sens_out,
            val_out   => tb_val_out
        );

    -- Génération de l'horloge
    clk_process : process
    begin
        tb_clk <= '0';
        wait for clk_period / 2;
        tb_clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Séquence de test
    stim_proc: process
    begin
        -- 1. Reset initial
        tb_rst_n <= '0';
        tb_charg_reg <= '0';
        tb_sens_in <= '0';
        tb_val_in <= "0000";
        wait for 20 ns;
        
        tb_rst_n <= '1';
        wait for 20 ns;

        -- 2. Test sans charger (ChargReg = 0) -> rien ne doit changer
        tb_sens_in <= '1';
        tb_val_in <= "1010";
        tb_charg_reg <= '0';
        wait for 20 ns;

        -- 3. Test avec chargement (ChargReg = 1) -> la valeur doit passer en sortie
        tb_charg_reg <= '1';
        wait for 20 ns;

        -- 4. Changement des entrées en désactivant le chargement
        tb_charg_reg <= '0';
        tb_sens_in <= '0';
        tb_val_in <= "0101";
        wait for 20 ns;

        -- 5. Nouveau chargement d'une autre valeur
        tb_charg_reg <= '1';
        tb_sens_in <= '0';
        tb_val_in  <= "1111";
        wait for 20 ns;

        tb_charg_reg <= '0';
        wait for 30 ns;
        
        wait;
    end process;

end architecture tb;