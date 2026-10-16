library ieee;
  use ieee.std_logic_1164.all;

--    -a-
--  |f| |b|
--    -g-
--  |e| |c|
--    -d-

entity decoder is
  port (
    i_data : in    std_logic_vector(3 downto 0);
    o_data : out   std_logic_vector(6 downto 0) -- "abcdefg"
  );
end entity decoder;

architecture rtl of decoder is

begin

  o_data <= "1111110" when i_data = "0000" else
            "0110000" when i_data = "0001" else
            "1101101" when i_data = "0010" else
            "1111001" when i_data = "0011" else
            "0110011" when i_data = "0100" else
            "1011011" when i_data = "0101" else
            "1011111" when i_data = "0110" else
            "1110000" when i_data = "0111" else
            "1111111" when i_data = "1000" else
            "1111011" when i_data = "1001" else
            (others => '0');

end architecture rtl;
