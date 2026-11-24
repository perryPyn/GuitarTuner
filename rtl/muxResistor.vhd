library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity muxresistor is
  port (
    i_signal : in    std_logic;
    sel   : in    std_logic_vector(2 downto 0);
    o_r_329 : out   std_logic;
    o_r_246 : out   std_logic;
    o_r_196 : out   std_logic;
    o_r_146 : out   std_logic;
    o_r_110 : out   std_logic;
    o_r_82  : out   std_logic
  );
end entity muxresistor;

architecture rtl of muxresistor is

begin

  p_mux : process (i_signal, sel) is
  begin

    if (sel = "000") then
      o_r_329 <= i_signal;
    elsif (sel = "001") then
      o_r_246 <= i_signal;
    elsif (sel = "010") then
      o_r_196 <= i_signal;
    elsif (sel = "011") then
      o_r_146 <= i_signal;
    elsif (sel = "100") then
      o_r_110 <= i_signal;
    elsif (sel = "101") then
      o_r_82 <= i_signal;
    else
      o_r_329 <= i_signal;
    end if;

  end process p_mux;

end architecture rtl;
