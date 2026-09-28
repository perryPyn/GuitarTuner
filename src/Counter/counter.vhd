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

    -- constant h_max : signed := 100;
    -- constant h_min : signed := 0;
  signal r_cnt : integer range 0 to 100; -- Should use constant for boundaries or usless ?

begin

  process (i_freq_ref, i_rst_n)
  begin

    if (i_rst_n = '0') then
      o_etat_0 <= '0';
      r_cnt <= 0;

    elsif (rising_edge(i_freq_ref)) then
      if (i_init_cnt = '1') then
        o_etat_0 <= '0';
        r_cnt <= 100;

      elsif (i_valid_cnt = '1') then
        if (i_sens_crois = '1') then
          r_cnt <= r_cnt + 1; -- Should be limited to avoid numbers above 100 ?

        else
          r_cnt <= r_cnt - 1; -- Should be limited to avoid negatives numbers ?

          if (r_cnt = 1) then
            o_etat_0 <= '1';
          end if;

        end if;

      end if;

    end if;
  end process;

  o_data <= std_logic_vector(to_unsigned(r_cnt, 4)); -- In C, would have put it in the loop to avoid useless
                                                     -- updates, but here it's in parallele (so no need) ?

end architecture rtl;
