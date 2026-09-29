library ieee;
use ieee.std_logic_1164.all;

entity divider is 

    port(
      -- Inputs
        i_rst_n : in std_logic;
        i_freq_var : in std_logic;
      -- Outputs
        o_measure : out std_logic := '0'
    );
end divider;

architecture rtl of divider is
begin
    process(i_freq_var, i_rst_n)

      variable r_count : natural range 0 to 100 := 0;

    begin
        if (i_rst_n ='0') then
            o_measure <= '0';
            r_count := 0;

        else
            if rising_edge(i_freq_var) then
                o_measure <= '1';
                r_count := r_count + 1;
            end if;

            if (r_count = 100) then
                o_measure <= '0';
                r_count := 0;
            end if;

        end if;

    end process;
end architecture rtl;

