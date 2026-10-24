library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_divider is
	generic(
		g_half : natural := 113636
	);
	port(
		i_clk : in std_logic;
		i_rst_n : in std_logic;
		o_en : out std_logic
	);
end clk_divider;

architecture rtl of clk_divider is

	signal r_cnt : natural range 0 to g_half := 0;
	signal r_ref : std_logic := '0';

begin

	p_clk_divider: process(i_clk, i_rst_n) is
	begin
		if (i_rst_n = '0') then
			r_cnt <= 0;
			r_ref <= '0';
		elsif (rising_edge(i_clk)) then
			if (r_cnt = g_half) then
				r_cnt <= 0;
				r_ref <= not r_ref;
			else
				r_cnt <= r_cnt + 1;
			end if;
		end if;
	end process;

	o_en <= r_ref;

end architecture rtl;
