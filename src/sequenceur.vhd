library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sequencer is
    port (
    --Inputs
        i_freq_ref    : in  std_logic;
        i_rst_n      : in  std_logic;
        i_mesure     : in  std_logic;
        i_etat_0     : in  std_logic;
    --Outputs
        o_init_compt  : out std_logic;
        o_valid_compt : out std_logic;
        o_sens_croiss : out std_logic;
        o_charg_reg   : out std_logic
    );
end entity sequencer;


architecture rtl of sequencer is

    -- We have to define first the states of the machine (for the sequencer the states are
    -- attente, decomptage, comptage, sauvegarde)

    type state_type is (ATTENTE, DECOMPTAGE, COMPTAGE, SAUVEGARDE);
    signal current_state, next_state : state_type;

--PART1--
      
    begin                         
        process(i_freq_ref, i_rst_n)           --In this part we implemented a reset so that we can force the system to be
        begin                                  --in the ATTENTE state or else to wait for a signal (i_freq_ref)
            if i_rst_n = '0' then
                current_state <= ATTENTE;
            elsif rising_edge(i_freq_ref) then 
                current_state <= next_state;
                end if;
        end process;

--PART2--
    process(current_state, i_mesure, i_etat_0)
    begin
        -- Valeurs par défaut pour éviter la mémorisation implicite (latchs)
        o_init_compt  <= '0';
        o_valid_compt <= '0';
        o_sens_croiss <= '0';
        o_charg_reg   <= '0';
        next_state    <= current_state;

        case current_state is
            -- État 1 : En attente du début de la mesure
            when ATTENTE =>
                o_init_compt <= '1';
                if i_mesure = '1' then
                    next_state <= DECOMPTAGE;
                end if;

            -- État 2 : Le compteur décompte pendant que la mesure est active
            when DECOMPTAGE =>
                o_valid_compt <= '1';
                o_sens_croiss <= '0'; -- Sens décrémentation
                if i_mesure = '0' then
                    next_state <= SAUVEGARDE;
                elsif i_etat_0 = '1' then
                    next_state <= COMPTAGE;
                end if;

            -- État 3 : Si l'état 0 est atteint, on compte à l'envers (croissant)
            when COMPTAGE =>
                o_valid_compt <= '1';
                o_sens_croiss <= '1'; -- Sens incrémentation
                if i_mesure = '0' then
                    next_state <= SAUVEGARDE;
                end if;

            -- État 4 : La mesure est finie, on sauvegarde le résultat dans le registre
            when SAUVEGARDE =>
                o_charg_reg <= '1';
                next_state  <= ATTENTE;

            when others =>
                next_state <= ATTENTE;
        end case;
    end process;

end architecture rtl;

            
