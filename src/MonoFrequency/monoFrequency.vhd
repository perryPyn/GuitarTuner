library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity monoFrequency is
  port (
  -- Inputs
    i_rst_n : in std_logic;
    i_freq_var : in std_logic;
    i_freq_ref : in std_logic;
  -- Outputs
    o_sens_crois : out std_logic;
    o_data  : out std_logic_vector(6 downto 0)
  );
end entity monoFrequency;

architecture rtl of monoFrequency is
-- Internal signals
  signal s_measure : std_logic;
  signal s_etat_0 : std_logic;
  signal s_init_compt  : std_logic;
  signal s_valid_compt : std_logic;
  signal s_sens_crois : std_logic;
  signal s_charg_reg   : std_logic;
  signal s_data_counter : std_logic_vector(3 downto 0);
  signal s_data_register : std_logic_vector(3 downto 0);
  -- signal s_data_7bits : std_logic_vector(7 downto 0);

begin
  
  u_divider : entity work.divider
    port map (
      i_rst_n => i_rst_n,
      i_freq_var => i_freq_var,
      o_measure => s_measure
             );

  u_sequencer : entity work.sequencer
    port map (
      i_freq_ref => i_freq_ref,
      i_rst_n => i_rst_n,
      i_mesure => s_measure,
      i_etat_0 => s_etat_0,

      o_init_compt => s_init_compt,
      o_valid_compt => s_valid_compt,
      o_sens_crois => s_sens_crois,
      o_charg_reg => s_charg_reg
             );

  u_counter : entity work.counter
    port map (
      i_rst_n => i_rst_n,
      i_freq_ref => i_freq_ref,

      i_init_cnt => s_init_compt,
      i_valid_cnt => s_valid_compt,
      i_sens_crois => s_sens_crois,
      o_etat_0 => s_etat_0,
      o_data => s_data_counter
             );

  u_register : entity work.registre
    port map (
      i_rst_n => i_rst_n,
      i_freq_ref => i_freq_ref,

      i_charg_reg => s_charg_reg,
      i_sens_crois => s_sens_crois,
      i_data => s_data_counter,

      o_sens_crois => o_sens_crois,
      o_data => s_data_register
             );

  u_decoder : entity work.decoder
    port map (
      i_rst_n => i_rst_n,

      i_data => s_data_register,

      o_data => o_data
             );

end architecture rtl;
