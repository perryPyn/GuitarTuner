library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
  port (
  -- Reset
    i_rst_n : in std_logic;
  -- Inputs
    i_freq_ref : in std_logic;
    i_init_cnt : in std_logic;
    i_valid_cnt : in std_logic;
    i_sens_crois : in std_logic;
  -- Outputs
    o_etat_0 : out std_logic;
    o_data : out std_logic_vector(3 downto 0)
  );
end entity counter;

architecture rtl of counter is

  signal s_cnt : natural range 0 to 100 := 0;

begin

  p_counter: process (i_freq_ref, i_rst_n)

  begin

    if (i_rst_n = '0') then
      o_etat_0 <= '0';
      s_cnt <= 100;
    
    else
      if (i_init_cnt = '1') then
        o_etat_0 <= '0';
        s_cnt <= 100;

      elsif (rising_edge(i_freq_ref)) and (i_valid_cnt = '1') then
        if (i_sens_crois = '1') then
          s_cnt <= s_cnt + 1; -- Should be limited to avoid numbers above 100 ?

        else
          s_cnt <= s_cnt - 1; -- Should be limited to avoid negatives numbers ?

        end if;
      end if;

      if (s_cnt = 0) then
        o_etat_0 <= '1';
      end if;

    end if;

  end process p_counter;

  o_data <= std_logic_vector(to_unsigned(s_cnt, 4));

end architecture rtl;
