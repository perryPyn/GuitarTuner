library ieee;
  use ieee.std_logic_1164.all;

--    -a-
--  |f| |b|
--    -g-
--  |e| |c|
--    -d-
-- (/!\ Attention les bits sont inversés sur la BASYS-2 (cf. boardPinout.md))

entity decoder is
  port (
    i_data : in    std_logic_vector(3 downto 0);
    o_data : out   std_logic_vector(6 downto 0) -- "abcdefg"
  );
end entity decoder;

architecture rtl of decoder is

begin

  o_data <= "1000000" when i_data = "0000" else
            "1111001" when i_data = "0001" else
            "0100100" when i_data = "0010" else
            "0110000" when i_data = "0011" else
            "0011001" when i_data = "0100" else
            "0010010" when i_data = "0101" else
            "0000010" when i_data = "0110" else
            "1111000" when i_data = "0111" else
            "0000000" when i_data = "1000" else
            "0010000" when i_data = "1001" else
				"0101111" when i_data = "1111" else -- "r" : RESET State
				"1000110" when i_data = "1110" else -- "C" : No clock rising_edge found
            "0000110";

end architecture rtl;