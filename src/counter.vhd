library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
  port (
  -- Reset
    i_rst_n : in std_logic;
  -- Inputs
    i_init_cnt : in std_logic;
    i_valid_cnt : in std_logic;
    i_sens_crois : in std_logic := '0';
    i_freq_ref : in std_logic;
  -- Outputs
    o_etat_0 : out std_logic;
    o_data : out std_logic_vector(3 downto 0)
  );
end entity counter;

architecture rtl of counter is

    -- constant c_max : signed := 100;
    -- constant h_min : signed := -100;
    -- signal r_cnt : natural range h_min to h_max := 0;
    signal r_cnt : integer range -100 to 100 := 0;

begin

  process (i_freq_ref, i_rst_n) -- Relié à la clock
  begin

    if (i_rst_n = '0') then
      o_etat_0 <= '0';

    elsif (rising_edge(i_freq_ref)) then
      if (i_init_cnt = '1') then
        r_cnt <= 100;

      elsif (i_valid_cnt = '1') then
        if (i_sens_crois = '1') then
          r_cnt <= r_cnt + 1;

        else
          r_cnt <= r_cnt - 1;

          if (r_cnt = 0) then
            o_etat_0 <= '1';
          end if;

        end if;

      end if;

    end if;
  end process;

end architecture rtl;
