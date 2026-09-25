# 🎸 JOS4 — Accordeur Numérique pour Guitare

[![VHDL](https://img.shields.io/badge/VHDL-Synth%C3%A9tisable-orange)](<>)
[![ModelSim](https://img.shields.io/badge/Simulation-ModelSim-blue)](<>)
[![Année](https://img.shields.io/badge/Ann%C3%A9e-2025--2026-lightgrey)](<>)
[![Statut](https://img.shields.io/badge/Avancement-En%20cours-yellow)](<>)

> Projet 2ème année — Concevoir un appareil d'accord musical pour guitare, capable de mesurer et d'afficher l'écart relatif entre la fréquence d'une corde jouée (`FreqVar`) et une fréquence de référence stockée en mémoire (`FreqRef`).

**Réalisé par :** Youssef, Jula, Lucas
**Encadrant :** Christian Josse

---

## 📑 Table des matières

- [1. Présentation du projet](#1-présentation-du-projet)
  - [1.1 Contexte et objectifs](#11-contexte-et-objectifs)
  - [1.2 Rappel sur l'accordage d'une guitare](#12-rappel-sur-laccordage-dune-guitare)
  - [1.3 Principe de fonctionnement](#13-principe-de-fonctionnement)
  - [1.4 Architecture globale du dispositif](#14-architecture-globale-du-dispositif)
  - [1.5 Contraintes de réalisation](#15-contraintes-de-réalisation)
  - [1.6 Plan de travail](#16-plan-de-travail)
- [2. Réponses au cahier des charges](#2-réponses-au-cahier-des-charges)
  - [2.1 Graphe d'état du séquenceur](#21--graphe-détat-du-séquenceur)
  - [2.2 Synthèse et schéma du séquenceur](#22--synthèse-et-schéma-de-réalisation-du-séquenceur)
  - [2.3 Schéma du diviseur](#23--schéma-du-diviseur)
  - [2.4 Schéma du compteur réversible](#24--schéma-du-compteur-réversible)
  - [2.5 Schéma du registre](#25--schéma-du-registre)

---

## 1. Présentation du projet

### 1.1 Contexte et objectifs

Il s'agit de concevoir un appareil d'accord musical de note pour guitare, réalisant les fonctions suivantes :

- Dans un premier temps, pouvoir choisir la note à accorder via un sélecteur manuel. Dans un second temps, le système devra s'auto-calibrer de façon à reconnaître par lui-même la note sur laquelle porte la comparaison. Un affichage visuel sous la forme d'un afficheur numérique et d'un bargraphe restituera, à la fréquence de référence choisie, l'écart en % par rapport à celle-ci.
- Se présenter sous la forme d'un dispositif **portable**, d'**encombrement réduit**.
- Avoir une **consommation électrique faible**, tout en garantissant des caractéristiques de fonctionnement fiables.

**Domaines de compétence mis en œuvre :** électronique analogique • électronique numérique.

### 1.2 Rappel sur l'accordage d'une guitare

L'accordage standard d'une guitare à six cordes, de la plus grave à la plus aiguë (de 6 à 1), est **Mi La Ré Sol Si Mi** (E A D G B E). Les cordes consécutives sont accordées à la quarte juste, sauf entre la 3ᵉ et la 2ᵉ corde où c'est une tierce majeure.

| Corde              | Note | Notation anglophone | Fréquence |
| ------------------ | ---- | ------------------- | --------- |
| 1 (la plus fine)   | Mi   | E                   | 329,6 Hz  |
| 2                  | Si   | B                   | 246,88 Hz |
| 3                  | Sol  | G                   | 196,0 Hz  |
| 4                  | Ré   | D                   | 146,79 Hz |
| 5                  | La   | A                   | 110,0 Hz  |
| 6 (la plus grosse) | Mi   | E                   | 82,4 Hz   |

### 1.3 Principe de fonctionnement

L'accord des cordes se fait en effectuant une **mesure comparative** de la note jouée avec une fréquence de référence stockée de façon fixe en mémoire :

```
FreqVar ──┐
          ├──▶ [ ± ⎡⎦ % ]
FreqRef ──┘
```

- `FreqRef` : signal de référence, de fréquence fixe.
- `FreqVar` : signal de fréquence variable (la note jouée).

L'écart entre les deux fréquences reste faible à tout moment et est supposé **ne jamais dépasser 9 %**. Le résultat est affiché en %, sur un chiffre signé.

Soient `T_Ref` et `T_Var` les périodes des deux signaux, et `n_f` l'état atteint par le compteur en fin d'activité de `Mesure` :

```
n_f = 100 × | (T_Var − T_Ref) / T_Ref |
```

Le signe de l'écart est donné par `SensCroiss`.

### 1.4 Architecture globale du dispositif

Le système repose sur une architecture synchrone cadencée par l'horloge de référence `FreqRef`. Le séquenceur, le compteur réversible et le registre partagent ce même signal d'horloge : leur fonctionnement est **synchrone**.

<p align="center">
  <img src="img/Structure.png" alt="Structure interne du dispositif" width="600"/>
</p>

| Bloc                        | Rôle                                                                                                                                                                                                                     |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 🔹 **Diviseur**             | Génère, de façon périodique et permanente, le signal `Mesure` à partir de l'horloge formée par `FreqVar`. `Mesure` est actif pendant 100 périodes de cette horloge, et inactif pendant un nombre quelconque de périodes. |
| 🔹 **Séquenceur**           | FSM qui pilote l'enchaînement des opérations en fonction de l'état de `Mesure` et du compteur.                                                                                                                           |
| 🔹 **Compteur réversible**  | Compteur synchrone, réversible, en code binaire naturel. Initialisé à l'état d'équivalent décimal 100, il décompte jusqu'à l'état 0 puis recompte, tant que `Mesure` est actif.                                          |
| 🔹 **Registre + Afficheur** | Le registre mémorise le sens (`SensCroiss`) et la valeur de l'écart (4 bits de poids faible du compteur) au chargement. L'afficheur (7 segments + signe) reflète en permanence cette information.                        |

`Etat_0` est actif dès que le compteur atteint l'état 0, quels que soient `InitCompt`, `ValidCompt` et `SensCroiss`.

### 1.5 Contraintes de réalisation

Tous les sous-ensembles du dispositif doivent être conçus **uniquement** à partir de :

- Portes **NAND** à 2, 4 ou 8 entrées ;
- Bascules **D** déclenchées sur front montant d'horloge ;
- Compteurs intégrés (synchrones, 4 bits, code binaire naturel, réversibles, déclenchés sur front montant d'horloge).

### 1.6 Plan de travail

| Phase       | Contenu                                                                                                                                                                                                               |
| ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Phase 1** | Conception et simulation comportementale complète du dispositif. Câblage d'une maquette et configuration d'un CPLD intégrant l'ensemble des fonctions numériques. Test du circuit pour validation.                    |
| **Phase 2** | Reprise de l'étude en vue d'une optimisation. Finalisation d'un circuit imprimé mettant en œuvre le CPLD, avec comparaison des performances à l'étude précédente (réduction de la consommation et de l'encombrement). |

Le cahier des charges demande de traiter, dans l'ordre, les **5 points** suivants — détaillés section par section ci-dessous :

1. Établir le graphe d'état du séquenceur.
2. Effectuer la synthèse du séquenceur et proposer un schéma de réalisation.
3. Proposer un schéma du diviseur.
4. Proposer un schéma du compteur réversible.
5. Proposer un schéma du registre.

---

## 2. Réponses au cahier des charges

### 2.1 ✅ Graphe d'état du séquenceur

Le comportement du séquenceur est modélisé par une **machine d'états finis synchrone** comportant quatre états principaux :

| État           | Description                                                                                                                                        |
| -------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| **ATTENTE**    | Au repos, initialise le compteur et attend l'activation de la fenêtre `Mesure`.                                                                    |
| **DECOMPTAGE** | Dès que `Mesure` passe à l'état haut, le compteur décrémente à chaque front d'horloge. Si l'état zéro est atteint, la machine bascule en comptage. |
| **COMPTAGE**   | Le compteur repart à la hausse pour mesurer l'écart positif restant.                                                                               |
| **SAUVEGARDE** | À la fin de la fenêtre de mesure, le résultat est figé dans le registre avant de retourner à l'état `ATTENTE`.                                     |

<p align="center">
  <img src="img/Sequenc.png" alt="Graphe d'états du séquenceur" width="500"/>
</p>

### 2.2 ✅ Synthèse et schéma de réalisation du séquenceur

L'implémentation matérielle en VHDL sépare strictement :

- la **logique séquentielle**, synchronisée sur le front montant de l'horloge `i_freq_ref` ;
- la **logique combinatoire**, via un bloc `case` avec des valeurs par défaut pour éviter les latches parasites.

<details>
<summary>📄 Voir le code VHDL du séquenceur (<code>sequencer.vhd</code>)</summary>

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sequencer is
    port (
        i_freq_ref    : in  std_logic;
        i_rst_n       : in  std_logic;
        i_mesure      : in  std_logic;
        i_etat_0      : in  std_logic;
        o_init_compt  : out std_logic;
        o_valid_compt : out std_logic;
        o_sens_croiss : out std_logic;
        o_charg_reg   : out std_logic
    );
end entity sequencer;

architecture rtl of sequencer is
    type state_type is (ATTENTE, DECOMPTAGE, COMPTAGE, SAUVEGARDE);
    signal current_state, next_state : state_type;
begin

    -- Processus séquentiel : mise à jour de l'état sur front d'horloge
    process(i_freq_ref, i_rst_n)
    begin
        if i_rst_n = '0' then
            current_state <= ATTENTE;
        elsif rising_edge(i_freq_ref) then
            current_state <= next_state;
        end if;
    end process;

    -- Processus combinatoire : calcul de l'état futur et des sorties
    process(current_state, i_mesure, i_etat_0)
    begin
        o_init_compt  <= '0';
        o_valid_compt <= '0';
        o_sens_croiss <= '0';
        o_charg_reg   <= '0';
        next_state    <= current_state;

        case current_state is
            when ATTENTE =>
                o_init_compt <= '1';
                if i_mesure = '1' then
                    next_state <= DECOMPTAGE;
                end if;

            when DECOMPTAGE =>
                o_valid_compt <= '1';
                o_sens_croiss <= '0';
                if i_mesure = '0' then
                    next_state <= SAUVEGARDE;
                elsif i_etat_0 = '1' then
                    next_state <= COMPTAGE;
                end if;

            when COMPTAGE =>
                o_valid_compt <= '1';
                o_sens_croiss <= '1';
                if i_mesure = '0' then
                    next_state <= SAUVEGARDE;
                end if;

            when SAUVEGARDE =>
                o_charg_reg <= '1';
                next_state  <= ATTENTE;

            when others =>
                next_state <= ATTENTE;
        end case;
    end process;

end architecture rtl;
```

</details>

**Validation par simulation (ModelSim)**

Le comportement dynamique du circuit a été validé par **simulation comportementale sous ModelSim**.

<p align="center">
  <img src="img/ModelSim.png" alt="Chronogramme de simulation ModelSim du séquenceur" width="700"/>
</p>

- 🟦 Le signal de reset asynchrone `i_rst_n` (en haut, cyan) initialise proprement le système dans l'état `ATTENTE`.
- 🟧 Dès l'activation de `i_mesure` (orange), la machine passe de `ATTENTE` à `DECOMPTAGE`.
- ⚡ L'impulsion sur `i_etat_0` déclenche la transition vers `COMPTAGE` (inversion du sens).
- 🔁 Enfin, le retour à zéro de `i_mesure` déclenche l'état `SAUVEGARDE` (activation de `o_charg_reg`), bouclant parfaitement le cycle avant de retourner au repos.

---

### 2.3 ⏳ Schéma du diviseur

**Statut : à compléter.**

Rappel du besoin (cahier des charges) : le diviseur doit générer, de façon périodique et permanente, le signal `Mesure` à partir de l'horloge formée par `FreqVar`. `Mesure` doit être actif pendant exactement 100 périodes de cette horloge, et inactif pendant un nombre quelconque (à fixer librement) de périodes.

> _À faire : proposer un schéma de réalisation à base de compteurs intégrés / bascules D / portes NAND, et documenter la démarche de conception ici._

### 2.4 ⏳ Schéma du compteur réversible

**Statut : à compléter.**

Rappel du besoin (cahier des charges) : compteur synchrone, réversible, en code binaire naturel, déclenché sur front montant d'horloge, avec le comportement suivant :

```
Si InitCompt est actif
    Le compteur est positionné à l'état d'équivalent décimal 100
Sinon
    Si ValidCompt est actif
        Si SensCroiss est actif
            Le compteur est incrémenté à chaque période d'horloge
        Sinon
            Le compteur est décrémenté
    Sinon
        L'état du compteur est maintenu inchangé
```

> _À faire : proposer un schéma de réalisation et documenter la démarche de conception ici._

### 2.5 ⏳ Schéma du registre

**Statut : à compléter.**

Rappel du besoin (cahier des charges) : registre synchrone, déclenché sur front montant d'horloge :

```
Si ChargReg est actif
    Le registre est chargé par l'état du compteur
Sinon
    Le contenu du registre n'est pas modifié
```

> _À faire : proposer un schéma de réalisation et documenter la démarche de conception ici._

