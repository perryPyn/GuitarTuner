library ieee;
  use ieee.std_logic_1164.all;

-- Codes d'erreur (cf. decoder.vhd) :
--   "1111" -> "r" : reset appliqué
--   "1110" -> "C" : probqblement pqs de signql en entrée (période infinie)
--   "0000".."1001" : écart mesuré en %

entity registre is
  port (
    i_clk        : in    std_logic;
    i_en         : in    std_logic;
    i_rst_n      : in    std_logic;
    i_charg_reg  : in    std_logic;
    i_sens_crois : in    std_logic;
    i_data       : in    std_logic_vector(3 downto 0);
    o_sens_crois : out   std_logic;
    o_data       : out   std_logic_vector(3 downto 0)
  );
end entity registre;

architecture rtl of registre is

  signal r_loaded : std_logic;

begin

  p_registre : process (i_clk, i_en, i_rst_n) is
  begin

    if (i_rst_n = '0') then
      o_sens_crois <= '0';
      o_data       <= "1111";               -- "r"
      r_loaded     <= '0';
    elsif rising_edge(i_clk) then
      if (i_en = '1') then
        if (i_charg_reg = '1') then
          o_sens_crois <= i_sens_crois;
          o_data       <= i_data;
          r_loaded     <= '1';
        elsif (r_loaded = '0') then
          o_data <= "1110";                 -- "C" : horloge détectée
        end if;
      end if;
    end if;

  end process p_registre;

end architecture rtl;
