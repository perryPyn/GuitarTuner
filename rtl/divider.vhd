library ieee;
  use ieee.std_logic_1164.all;

entity divider is
  port (
    -- Inputs
    i_rst_n    : in    std_logic;
    i_freq_var : in    std_logic;
    -- Outputs
    o_measure : out   std_logic
  );
end entity divider;

architecture rtl of divider is

  constant c_rest    : natural := 10;
  constant c_measure : natural := 100;
  constant c_active  : natural := c_measure + c_rest;

  signal s_count : natural range 0 to c_active;

begin

  p_divider : process (i_freq_var, i_rst_n) is
  begin

    if (i_rst_n = '0') then
      s_count <= 0;
    elsif (rising_edge(i_freq_var)) then
      if (s_count = c_active) then
        s_count <= 0;
      else
        s_count <= s_count + 1;
      end if;
    end if;

  end process p_divider;

  o_measure <= '1' when (s_count > c_rest) else
               '0';

end architecture rtl;

