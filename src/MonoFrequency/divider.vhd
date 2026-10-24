library ieee;
use ieee.std_logic_1164.all;

entity divider is
  generic(
    g_idle : positive := 10
  );
  port(
  -- Inputs
    i_rst_n : in std_logic;
    i_freq_var : in std_logic;
  -- Outputs
    o_measure : out std_logic
  );
end divider;

architecture rtl of divider is

  constant c_active : natural := 100;
  constant c_last   : natural := c_active + g_idle - 1;

  signal s_count : natural range 0 to c_last := 0;

begin
  p_divider: process(i_freq_var, i_rst_n)
  begin
    if (i_rst_n = '0') then
      s_count <= 0;
    elsif (rising_edge(i_freq_var)) then
      if (s_count = c_last) then
        s_count <= 0;
      else
        s_count <= s_count + 1;
      end if;
    end if;
  end process p_divider;

  -- Valeurs 0..99 : 100 périodes actives ; 100..c_last : g_idle périodes inactives
  o_measure <= '1' when (s_count < c_active) else '0';

end architecture rtl;

