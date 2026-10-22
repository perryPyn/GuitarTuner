library ieee;
use ieee.std_logic_1164.all;

entity monoFrequency_tb is
end entity monoFrequency_tb;

architecture tb of monoFrequency_tb is
  -- Contants for generating var signal
    constant c_freq_ref : natural := 110;
    constant c_freq_error : integer := 0;
    constant c_half_period_ref : time := 1 sec / (2 * c_freq_ref);
    constant c_half_period_var : time := c_half_period_ref * 100 / (100 + c_freq_error);
  -- Clock constant
    constant c_freq_clk : natural := 25000000;
    constant c_half_period_clk : time := 1 sec / (2 * c_freq_clk);
  -- Inputs
    signal i_rst_n : std_logic;
    signal i_freq_var : std_logic;
    signal i_clk : std_logic;
  -- Outputs
    signal o_sens_crois : std_logic;
    signal o_data  : std_logic_vector(6 downto 0);
  -- Clock
    signal isDone : boolean := false;

begin

  uut : entity work.monoFrequency

    port map (
      i_rst_n => i_rst_n,
      i_freq_var => i_freq_var,
      i_clk => i_clk,
      o_sens_crois => o_sens_crois,
      o_data => o_data
             );


    clock_ref: process -- Simulation du signal généré
    begin
      i_clk <= '0';
      wait for c_half_period_clk;

      i_clk <= '1';
      wait for c_half_period_clk;

      if (isDone) then
        wait;
      end if;
    end process clock_ref;

    clock_var: process -- Simulation du signal reçu
    begin
      i_freq_var <= '0';
      wait for c_half_period_var;

      i_freq_var <= '1';
      wait for c_half_period_var;

      if (isDone) then
        wait;
      end if;
    end process clock_var;

    stimuli: process
    begin
      i_rst_n <= '0';
      wait for 9 ms;

      i_rst_n <= '1';
      wait for 9 ms;


      for i in 0 to 120 loop
        wait for 9 ms;
      end loop;

      isDone <= true;
      wait;

    end process stimuli;

end architecture tb;
