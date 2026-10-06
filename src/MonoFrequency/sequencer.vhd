library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity sequencer is
  port (
    -- Inputs
    i_freq_ref : in    std_logic;
    i_rst_n    : in    std_logic;
    i_mesure   : in    std_logic;
    i_etat_0   : in    std_logic;
    -- Outputs
    o_init_compt  : out   std_logic;
    o_valid_compt : out   std_logic;
    o_sens_crois  : out   std_logic;
    o_charg_reg   : out   std_logic
  );
end entity sequencer;

architecture rtl of sequencer is

  -- We have to define first the states of the machine (for the sequencer the states are
  -- attente, decomptage, comptage, sauvegarde)

  type state_type is (attente, decomptage, comptage, sauvegarde);

  signal current_state, next_state : state_type;

-- PART1--

begin

  p_sync : process (i_freq_ref, i_rst_n) is           -- In this part we implemented a reset so that we can force the system to be
  begin                                  -- in the ATTENTE state or else to wait for a signal (i_freq_ref)

    if (i_rst_n = '0') then
      current_state <= attente;
    elsif rising_edge(i_freq_ref) then
      current_state <= next_state;
    end if;

  end process p_sync;

  -- PART2--
  state_machine : process (current_state, i_mesure, i_etat_0) is
  begin

    -- Valeurs par défaut pour éviter la mémorisation implicite (latchs)
    o_init_compt  <= '0';
    o_valid_compt <= '0';
    -- o_sens_crois <= '0'; -- Sinon impose sens_crois = '0' pendant la sauvegarde (on veut qu'il reste en mémoire pour le coup)
    o_charg_reg <= '0';
    next_state  <= current_state;

    case current_state is

      -- État 1 : En attente du début de la mesure
      when attente =>

        o_init_compt <= '1';
        o_sens_crois  <= '0';

        if (i_mesure = '1') then
          o_init_compt <= '0';
          o_valid_compt <= '1';
          next_state <= decomptage;
        end if;

      -- État 2 : Le compteur décompte pendant que la mesure est active
      when decomptage =>

        o_valid_compt <= '1';
        o_sens_crois  <= '0';           -- Sens décrémentation

        -- IF séparés nécessaires pour éviter un d'écalage d'horloge (1 pour le changement de signe, 1 pour l'arrêt de la mesure)
        if (i_etat_0 = '1') then
          o_sens_crois <= '1';          -- Seul moyen d'éviter le cycle d'horloge de décalage
          next_state   <= comptage;
        end if;

        if (i_mesure = '0') then
          o_valid_compt <= '0'; -- osef
          next_state <= sauvegarde;
        end if;

      -- État 3 : Si l'état 0 est atteint, on compte à l'envers (croissant)
      when comptage =>

        o_valid_compt <= '1';
        o_sens_crois  <= '1';           -- Sens incrémentation

        if (i_mesure = '0') then
          o_valid_compt <= '0'; -- osef
          next_state <= sauvegarde;
        end if;

      -- État 4 : La mesure est finie, on sauvegarde le résultat dans le registre
      when sauvegarde =>

        o_charg_reg   <= '1';
        o_valid_compt <= '0';
        -- o_init_compt <= '1';
        next_state <= attente;

      when others =>

        o_init_compt <= '1';
        next_state   <= attente;

    end case;

  end process state_machine;

end architecture rtl;
