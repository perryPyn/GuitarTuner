library ieee;
use ieee.std_logic_1164.all;

entity divider is 

    port(
        
        i_reset : in std_logic; 
        i_freqVar : in std_logic;

        
        o_measure : out std_logic := '0';

        r_count : out integer:= 0


    );
end divider;

architecture rtl of divider is

    --signal r_count : positive := 0;

begin 
    process(i_freqVar, i_reset)
    begin
        if (i_reset ='0') then
            o_measure <= '0';
            r_count <= 0;

        else 
            if rising_edge(i_freqVar) and (r_count < 100) then
                o_measure <= '1';
                r_count <= r_count + 1;
            
            elsif (r_count >= 100) then
                o_measure <= '0';
                
            end if;
            
        end if;

    end process;
end architecture rtl;

