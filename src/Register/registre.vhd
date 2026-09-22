library ieee;
use ieee.std_logic_1164.all;

entity registre is
    port (
        clk      : in  std_logic;                    -- Horloge (FreqRef)
        rst_n    : in  std_logic;                    -- Reset asynchrone actif bas
        charg_reg: in  std_logic;                    -- Signal de commande (ChargReg)
        sens_in  : in  std_logic;                    -- Entrée du sens (SensCroiss)
        val_in   : in  std_logic_vector(3 downto 0); -- Entrée des 4 bits de données
        sens_out : out std_logic;                    -- Sortie mémorisée du sens
        val_out  : out std_logic_vector(3 downto 0)  -- Sortie mémorisée des 4 bits
    );
end entity registre;

architecture rtl of registre is
begin
    process (clk, rst_n)
    begin
        if (rst_n = '0') then
            sens_out <= '0';
            val_out  <= (others => '0');
        elsif rising_edge(clk) then
            if (charg_reg = '1') then
                sens_out <= sens_in;
                val_out  <= val_in;
            end if;
        end if;
    end process;
end architecture rtl;