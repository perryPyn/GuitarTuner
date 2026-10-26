library ieee;
use ieee.std_logic_1164.all;

entity counter_tb is
end entity counter_tb;

architecture tb of counter_tb is
  -- Reset
    signal i_rst_n : std_logic := '0';
  -- Inputs
    signal i_init_cnt : std_logic := '0';
    signal i_valid_cnt : std_logic := '0';
    signal i_sens_crois : std_logic := '0';
    signal i_freq_ref : std_logic := '0';
  -- Outputs
    signal o_data : std_logic_vector(3 downto 0);
    signal o_etat_0 : std_logic := '0';
  -- Clock
    signal isDone : boolean := false;

begin
  
  uut : entity work.counter
    port map (
      i_rst_n => i_rst_n,
      i_init_cnt => i_init_cnt,
      i_valid_cnt => i_valid_cnt,
      i_sens_crois => i_sens_crois,
      i_en  => i_freq_ref,
      i_clk => i_freq_ref,

      o_etat_0 => o_etat_0,
      o_data => o_data
    );

    clock: process
    begin
      i_freq_ref <= '1';
      wait for 4500 ns;
      i_freq_ref <= '0';
      wait for 4500 ns;

      if (isDone) then
        wait;
      end if;
    end process clock;
  
    process
    begin
      i_rst_n <= '0';
      wait until rising_edge(i_freq_ref);
      i_rst_n <= '1';
      wait until rising_edge(i_freq_ref);

      i_init_cnt <= '1'; -- Init of cnt
      wait until rising_edge(i_freq_ref);

      i_init_cnt <= '0'; -- It is init so next step is incr
      wait until rising_edge(i_freq_ref);

      i_valid_cnt <= '1';
      wait until rising_edge(i_freq_ref);

      i_sens_crois <= '0';

      wait until o_etat_0 = '1'; -- Simulate sequencer response
      i_sens_crois <= '1';       -- Should be one clock tick away ??
                                 -- issue with changement of state at '1' instead of '0'
 
      for i in 0 to 8 loop
          wait until rising_edge(i_freq_ref);
      end loop;

      isDone <= true;
      wait;
    end process;

end architecture tb;
