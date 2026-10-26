library ieee;
use ieee.std_logic_1164.all;

entity divider_tb is
    -- Entity of a test bench is always empty
end entity divider_tb;

architecture tb of divider_tb is

    signal i_reset_n : std_logic; 
    signal i_freqVar : std_logic;

    signal o_measure : std_logic := '0';
    

    signal done : BOOLEAN := false ;


begin 
    uut : entity work.divider
        port map (
            i_reset_n => i_reset_n,
            i_freqVar => i_freqVar,

            o_measure => o_measure
        );

    clock : process 
    begin
        i_freqVar <= '1';
        wait for 4500 ns;
        i_freqVar <= '0';
        wait for 4500 ns;

        if done then
            wait;
        end if;
    end process clock;

    gate : process
    begin
        i_reset_n <= '0';
        wait until (rising_edge(i_freqVar));

        i_reset_n <= '1';
        wait until (rising_edge(i_freqVar));

        for i in 0 to 105 loop
            wait until (rising_edge(i_freqVar));
        end loop;
        
        done <= true; 
        wait;
         
        
    end process gate;

end architecture tb;
