library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_divider is
	port(
		i_clk : in std_logic;
		i_rst_n : in std_logic;
		o_freq_ref : out std_logic
	);
end clk_divider;

architecture rtl of clk_divider is

  signal r_cnt : natural range 0 to 227273 := 0;
  signal r_en : natural range 0 to 1 := 0;

begin

	p_clk_divider: process(i_clk) is
	begin
		if (i_rst_n = '0') then
			o_freq_ref <= '0';
			r_cnt <= 0;
		else
			if (r_cnt = 227273) then
				r_cnt <= 0;
				if (r_en = 0) then
					r_en <= 1;
					o_freq_ref <= '0';
				else
					r_en <= 0;
					o_freq_ref <= '1';
        end if;
			else
				r_cnt <= r_cnt + 1;
			end if;
		end if;
	end process;

end architecture rtl;
