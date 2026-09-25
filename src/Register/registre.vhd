library ieee;
use ieee.std_logic_1164.all;

entity registre is
    port (
        i_clk      : in  std_logic;                    -- Horloge (FreqRef)
        i_rst_n    : in  std_logic;                    -- Reset asynchrone actif bas
        i_charg_reg: in  std_logic;                    -- Signal de commande (ChargReg)
        i_sens_crois  : in  std_logic;                    -- Entrée du sens (SensCroiss)
        i_data   : in  std_logic_vector(3 downto 0); -- Entrée des 4 bits de données
        o_sens_crois : out std_logic;                    -- Sortie mémorisée du sens
        o_data  : out std_logic_vector(3 downto 0)  -- Sortie mémorisée des 4 bits
    );
end entity registre;

architecture rtl of registre is
begin
    process (i_clk, i_rst_n)
    begin
        if (i_rst_n = '0') then
            o_sens_crois <= '0';
            o_data  <= (others => '0');
        elsif rising_edge(i_clk) then
            if (i_charg_reg = '1') then
                o_sens_crois <= i_sens_crois;
                o_data  <= i_data;
            end if;
        end if;
    end process;
end architecture rtl;
