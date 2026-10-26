library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity clk_divider is
  generic (
    g_internal_frequency : natural := 25000000;
    g_target_frequency   : natural := 110
  );
  port (
    i_clk   : in    std_logic;
    i_rst_n : in    std_logic;
    o_en    : out   std_logic
  );
end entity clk_divider;

architecture rtl of clk_divider is

  constant c_max_cnt : positive := g_internal_frequency / g_target_frequency;
  signal   s_cnt     : natural range 0 to c_max_cnt;

begin

  p_clk_divider : process (i_clk, i_rst_n) is
  begin

    if (i_rst_n = '0') then
      s_cnt <= 0;
      o_en  <= '0';
    elsif (rising_edge(i_clk)) then
      if (s_cnt = c_max_cnt - 1) then
        s_cnt <= 0;
        o_en  <= '1';
      else
        s_cnt <= s_cnt + 1;
        o_en  <= '0';
      end if;
    end if;

  end process p_clk_divider;

end architecture rtl;
