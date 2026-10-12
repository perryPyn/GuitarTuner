library ieee;
  use ieee.std_logic_1164.all;

--    -a-
--  |f| |b|
--    -g-
--  |e| |c|
--    -d-

entity decoder is
  port (
    i_rst_n : in    std_logic;
    i_data  : in    std_logic_vector(3 downto 0);
    o_data  : out   std_logic_vector(6 downto 0) -- "abcdefg"
  );
end entity decoder;

architecture rtl of decoder is

begin

  p_decoder : process (i_rst_n, i_data) is
  begin

    if (i_rst_n = '0') then
      o_data <= "0000000";
    else

      case (i_data) is

        when "0000" =>

          o_data <= "1111110";

        when "0001" =>

          o_data <= "0110000";

        when "0010" =>

          o_data <= "1101101";

        when "0011" =>

          o_data <= "1111001";

        when "0100" =>

          o_data <= "0110011";

        when "0101" =>

          o_data <= "1011011";

        when "0110" =>

          o_data <= "1011111";

        when "0111" =>

          o_data <= "1110000";

        when "1000" =>

          o_data <= "1111111";

        when "1001" =>

          o_data <= "1111011";

        when others =>

          o_data <= "1001111"; -- "E" in case of unknown number i.e. not in range [0,9]

      end case;

    end if;

  end process p_decoder;

end architecture rtl;
