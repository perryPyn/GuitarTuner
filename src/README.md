# 🎸 Projet FPGA : Accordeur Numérique pour Guitare

Bienvenue sur le dépôt du projet d'électronique numérique de conception d'un **accordeur numérique pour guitare** réalisé dans le cadre du module FPGA à l'ENSEA.

---

## 📌 Partie 1 : Présentation Générale du Projet

### Objectif et Contexte
L'objectif de ce projet est de concevoir un système matériel synchrone capable de mesurer et d'afficher l'écart relatif entre la fréquence d'une corde de guitare jouée par l'utilisateur (`FreqVar`) et une fréquence de référence stockée en mémoire (`FreqRef`). 

Dans les conditions nominales d'utilisation, l'écart de fréquence entre les deux signaux reste faible et ne dépasse jamais $\pm 9\%$. Le système s'auto-calibre pour restituer cet écart en pourcentage sur un afficheur numérique avec signe.

### Architecture Globale du Dispositif
Le système repose sur une architecture synchrone cadencée par l'horloge de référence `FreqRef` et s'articule autour de quatre grands blocs matériels interconnectés :
1. **Le Diviseur :** Génère une fenêtre temporelle active (`Mesure`) d'une durée exacte de $100 \cdot T_{Var}$.
2. **Le Séquenceur (FSM) :** Le "chef d'orchestre" qui pilote l'enchaînement des opérations en fonction de l'état de la mesure et du compteur.
3. **Le Compteur Réversible :** Un compteur synchrone initialisé à la valeur 100, qui décompte puis recompte selon le chronomètre de mesure.
4. **Le Registre et l'Afficheur :** Mémorise le score final et le sens d'évolution pour l'afficher en temps réel.

---

## 🔬 Partie 2 : Compte-Rendu Technique & Analyse Détaillée

### 1. Principe de la Mesure et Fondements Mathématiques

Soient $T_{Ref}$ et $T_{Var}$ les périodes respectives du signal de référence et du signal de la corde jouée. 
Le diviseur délivre un signal `Mesure` actif pendant une durée de $100 \cdot T_{Var}$. Le compteur réversible, initialisé à l'équivalent décimal $100$, évolue pendant cette fenêtre. 

Si $n_f$ représente l'état atteint par le compteur et $SensCroiss_f$ la sélection du sens d'évolution en fin d'activité de `Mesure` ($0$ : décomptage, $1$ : comptage), le nombre d'états parcourus s'exprime par :
$$100 \cdot T_{Var} = \left[ 100 + (-1)^{SensCroiss_f} \cdot n_f \right] T_{Ref}$$

La valeur de l'écart relatif en pourcentage est ainsi donnée par :
$$\text{Écart} = n_f \cdot \left\vert{} \frac{T_{Var} - T_{Ref}}{T_{Ref}} \right\vert{} \quad \text{avec son signe donné par } SensCroiss_f$$

---

### 2. Description Détaillée des Sous-Ensembles

#### A. Le Diviseur de Fréquence
* **Rôle :** Produit le signal rectangulaire `Mesure` périodique.
* **Fonctionnement :** Il compte les fronts montants du signal de la corde `FreqVar`. La sortie `Mesure` est positionnée à `1` pendant 100 périodes de `FreqVar`, puis à `0` le reste du temps pour permettre la mémorisation et l'affichage.

#### B. Le Séquenceur (Machine d'États FSM)
Le séquenceur est une machine synchrone à 4 états gérée par un processus séquentiel (sur front montant de `FreqRef`) et un processus combinatoire :
1. **`ATTENTE`** : Système au repos. `o_init_compt = '1'`. Attend le front montant de `i_mesure`.
2. **`DECOMPTAGE`** : Dès que `i_mesure = '1'`, le compteur décrémente (`o_valid_compt = '1'`, `o_sens_croiss = '0'`). Si le compteur atteint zéro (`i_etat_0 = '1'`), la machine bascule en comptage.
3. **`COMPTAGE`** : Le compteur repart à la hausse (`o_sens_croiss = '1'`) jusqu'à la fin de la fenêtre de mesure.
4. **`SAUVEGARDE`** : À la désactivation de `i_mesure`, le registre fige la valeur (`o_charg_reg = '1'`) avant de retourner dans l'état `ATTENTE`.

#### C. Le Compteur Réversible
* Constitué d'un additionneur/soustracteur synchrone de 7 bits paramétré via la bibliothèque standard `ieee.numeric_std`.
* Il intègre les commandes `InitCompt` (chargement de la valeur 100), `ValidCompt` (validation du comptage/décomptage) et `SensCroiss` (choix du sens d'incrémentation).
* La sortie combinatoire `Etat_0` bascule à `1` dès que la valeur interne atteint zéro.

#### D. Le Registre de Mémorisation (PIPO)
* Registre synchrone à chargement parallèle commandé par `ChargReg`. Il capture les 4 bits de poids faible de l'écart ainsi que le bit de signe, garantissant un affichage stable et sans scintillement.

---

### 3. Validation et Simulation (ModelSim)

Le comportement dynamique du circuit a été validé par simulation comportementale sous ModelSim.

![Chronogramme de simulation ModelSim du séquenceur](ModelSim.png)

* **Analyse du chronogramme :** 
  * Le signal de reset asynchrone `i_rst_n` (en haut, cyan) initialise proprement le système dans l'état `ATTENTE`.
  * Dès l'activation de `i_mesure` (orange), la machine passe de `ATTENTE` à `DECOMPTAGE`.
  * L'impulsion sur `i_etat_0` déclenche la transition vers `COMPTAGE` (inversion du sens).
  * Enfin, le retour à zéro de `i_mesure` déclenche l'état `SAUVEGARDE` (activation de `o_charg_reg`), bouclant parfaitement le cycle avant de retourner au repos.

---

### 4. Conclusion

L'implémentation en VHDL respecte scrupuleusement les règles de conception synchrone enseignées (séparation stricte de la logique séquentielle et combinatoire, absence de loutres/latches parasites grâce aux valeurs par défaut). Les simulations prouvent la conformité fonctionnelle du séquenceur et de l'ensemble de la chaîne de mesure de l'accordeur, ouvrant la voie au placement-routage sur la cible FPGA.