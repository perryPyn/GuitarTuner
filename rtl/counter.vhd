library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity counter is
  port (
    -- Reset
    i_rst_n : in    std_logic;
    -- Inputs
    i_clk        : in    std_logic;
    i_en         : in    std_logic;
    i_init_cnt   : in    std_logic;
    i_valid_cnt  : in    std_logic;
    i_sens_crois : in    std_logic;
    -- Outputs
    o_etat_0 : out   std_logic;
    o_data   : out   std_logic_vector(3 downto 0)
  );
end entity counter;

architecture rtl of counter is

  signal s_cnt : natural range 0 to 100;

begin

  p_counter : process (i_clk, i_en, i_rst_n) is
  begin

    if (i_rst_n = '0') then
      s_cnt <= 100;
    elsif rising_edge(i_clk) then
      if (i_en = '1') then
        -- Priorité à l'initialisation synchrone
        if (i_init_cnt = '1') then
          s_cnt <= 100;
        elsif (i_valid_cnt = '1') then
          if (i_sens_crois = '1') then
            -- Les limites ne devrait être atteintes mais déjà par sécurité
            -- C'est surtout que les mesures affichées seront entre +/- 9 donc devrait rien changer si le vecteur est tronqué
            if (s_cnt < 100) then
              s_cnt <= s_cnt + 1;
            end if;                                -- Limite haute
          else
            if (s_cnt > 0) then
              s_cnt <= s_cnt - 1;
            end if;                                -- Limite basse
          end if;
        end if;
      end if;
    end if;

  end process p_counter;

  -- Évite les latch
  o_etat_0 <= '1' when (s_cnt = 0) else
              '0';

  o_data <= std_logic_vector(to_unsigned(s_cnt, 4));

end architecture rtl;
