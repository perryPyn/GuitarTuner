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

  signal s_isDone : boolean := false;
  signal s_count : natural range 0 to 100 := 0;

begin
  p_divider: process(i_freq_var, i_rst_n)

  begin
    if (i_rst_n = '0') then
      s_isDone <= false;
      o_measure <= '0';
      s_count <= 0;

    elsif s_isDone then
    elsif (rising_edge(i_freq_var)) then
      if (s_count = 100) then
        s_isDone <= true;
        s_count <= 0;
        o_measure <= '0';
      else
        s_count <= s_count + 1;
        o_measure <= '1';
      end if;
    end if;

  end process p_divider;
end architecture rtl;

