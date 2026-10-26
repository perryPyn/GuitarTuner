library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity monofrequency is
  generic (
    -- g_ref_half : natural  := 227273;
    -- g_idle     : positive := 20;
    g_led_div : natural := 24
  );
  port (
    -- For test on the basys only :
    o_an         : out   std_logic_vector(3 downto 0);
    o_rst_n      : out   std_logic;
    o_led_clk    : out   std_logic; -- clignote si clock présente
    o_led_mesure : out   std_logic; -- ON lorsque mesure en cours
    -- Inputs
    i_rst      : in    std_logic;
    i_freq_var : in    std_logic;
    i_clk      : in    std_logic;
    -- Outputs
    o_sens_crois : out   std_logic;
    o_data       : out   std_logic_vector(6 downto 0)
  );
end entity monofrequency;

architecture rtl of monofrequency is

  -- For test on the basys only :
  signal r_heartbeat : unsigned(g_led_div downto 0);
  -- Internal signals
  signal s_rst_n         : std_logic;
  signal s_en            : std_logic;
  signal s_measure       : std_logic;
  signal s_etat_0        : std_logic;
  signal s_init_compt    : std_logic;
  signal s_valid_compt   : std_logic;
  signal s_sens_crois    : std_logic;
  signal s_charg_reg     : std_logic;
  signal s_data_counter  : std_logic_vector(3 downto 0);
  signal s_data_register : std_logic_vector(3 downto 0);

begin

  s_rst_n <= not(i_rst); -- Added signal to avoid having functions in port maps

  -- For test on the basys only :
  o_an    <= "0111";
  o_rst_n <= s_rst_n;

  p_heartbeat : process (i_clk) is -- Process to check if the clock is running
  begin

    if rising_edge(i_clk) then
      r_heartbeat <= r_heartbeat + 1;
    end if;

  end process p_heartbeat;

  o_led_clk    <= r_heartbeat(g_led_div);
  o_led_mesure <= s_measure;

  -- Instantiations
  u_clk_divider : entity work.clk_divider
    port map (
      i_rst_n => s_rst_n,
      i_clk   => i_clk,
      o_en    => s_en
    );

  u_divider : entity work.divider
    port map (
      i_rst_n    => s_rst_n,
      i_freq_var => i_freq_var,
      o_measure  => s_measure
    );

  u_sequencer : entity work.sequencer
    port map (
      i_clk    => i_clk,
      i_en     => s_en,
      i_rst_n  => s_rst_n,
      i_mesure => s_measure,
      i_etat_0 => s_etat_0,

      o_init_compt  => s_init_compt,
      o_valid_compt => s_valid_compt,
      o_sens_crois  => s_sens_crois,
      o_charg_reg   => s_charg_reg
    );

  u_counter : entity work.counter
    port map (
      i_rst_n => s_rst_n,
      i_clk   => i_clk,
      i_en    => s_en,

      i_init_cnt   => s_init_compt,
      i_valid_cnt  => s_valid_compt,
      i_sens_crois => s_sens_crois,
      o_etat_0     => s_etat_0,
      o_data       => s_data_counter
    );

  u_register : entity work.registre
    port map (
      i_rst_n => s_rst_n,
      i_clk   => i_clk,
      i_en    => s_en,

      i_charg_reg  => s_charg_reg,
      i_sens_crois => s_sens_crois,
      i_data       => s_data_counter,

      o_sens_crois => o_sens_crois,
      o_data       => s_data_register
    );

  u_decoder : entity work.decoder
    port map (
      i_data => s_data_register,
      o_data => o_data
    );

end architecture rtl;
