# Accordeur Numérique pour Guitare (Analogique & CPLD/FPGA)

Ce projet vise à concevoir un **accordeur numérique portable pour guitare** à faible consommation. Il intègre l'ensemble de la chaîne de traitement : de la captation acoustique analogique (microphone/filtrage) à la mesure numérique de fréquence et l'affichage des écarts sur un PCB personnalisé.

---

## 📌 Description du Projet

L'appareil mesure la fréquence fondamentale d'une corde de guitare jouée et indique l'écart en pourcentage par rapport à la fréquence de référence cible.

### Caractéristiques principales :
* **Modes de fonctionnement :**
  1. **Mode Sélection Manuel :** Choix direct de la note à accorder à l'aide d'un sélecteur.
  2. **Mode Auto-calibration :** Détection et reconnaissance automatique de la note jouée.
* **Affichage :**
  * **Afficheur 7-segments :** Indication numérique de la note ou du pourcentage d'écart.
  * **Bargraphe à LEDs :** Visualisation rapide du sens et de la valeur de l'accordage (trop bas / accordé / trop haut).
* **Contraintes de conception :** Format portable de taille réduite, faible consommation électrique et grande fiabilité de mesure.

---

## 📐 Architecture Globale du Système

Le système est découpé en deux grandes parties : la chaîne analogique de conditionnement du signal et le cœur de traitement numérique.

```
+-----------------------------------------------------------------------------------+
|                               CHAÎNE ANALOGIQUE                                   |
|                                                                                   |
|  [Microphone] ---> [ Préamplificateur ] ---> [ Filtre Passe-bas ] ---> [ Trigger  ] --+
|  / Entrée Jack          (AOP)                  (Anti-repliement)     de Schmitt   |
+-----------------------------------------------------------------------------------+
                                                                                        |
                                                                               Signal carré (FreqVar)
                                                                                        |
+-----------------------------------------------------------------------------------+   |
|                               CŒUR NUMÉRIQUE (VHDL)                               v   |
|                                                                                       |
|  [Diviseur Mesure] ---> [Séquenceur (FSM)] ---> [Compteur Réversible] ---> [Registre] |
|                                                                                 |     |
|                                                                                 v     |
|                                                           [Décodeur / Affichage] <----+
+-----------------------------------------------------------------------------------+
```

### 1. Chaîne Analogique (Conditionnement du Signal)
* **Captation / Entrée :** Microphone électret intégré ou entrée Jack direct pour guitare électrique.
* **Préamplification :** Amplification faible bruit (AOP) du signal millivoltrique émis par les cordes.
* **Filtrage actif :** Filtre passe-bas/passe-bande pour éliminer les harmoniques hautes fréquences et ne conserver que la fréquence fondamentale de la corde (80 Hz – 350 Hz).
* **Mise en forme (Mise en créneau) :** Comparateur à hystérésis (Trigger de Schmitt) convertissant le signal audio sinusoïdal filtré en un signal carré logique $0 - 3.3\text{ V}$ propre (`FreqVar`).

### 2. Cœur Numérique (Traitement VHDL)
* **`diviseur.vhd` :** Génère l'impulsion de fenêtre de mesure (`Mesure`) active pendant 100 périodes du signal `FreqVar`.
* **`sequencer.vhd` :** Machine à états (FSM synchrone) qui cadence les phases d'attente, de décomptage, de comptage et de sauvegarde dans le registre.
* **`counter.vhd` :** Compteur/décompteur de précision calculant la valeur d'écart relatif $\pm 9\%$.
* **`register.vhd` :** Mémorise le résultat de la mesure et le signe de l'écart (`SensCroiss`).
* **`display_controller.vhd` :** Pilotage du décodeur 7-segments et du bargraphe.

---

## 🎵 Accordage Standard & Fréquences de Référence

| Corde | Note (FR) | Note (US) | Fréquence Cible ($f_{\text{ref}}$) | Période ($T_{\text{ref}}$) |
| :---: | :---: | :---: | :---: | :---: |
| **1** (plus fine) | Mi | E4 | 329,60 Hz | 3,03 ms |
| **2** | Si | B3 | 246,88 Hz | 4,05 ms |
| **3** | Sol | G3 | 196,00 Hz | 5,10 ms |
| **4** | Ré | D3 | 146,79 Hz | 6,81 ms |
| **5** | La | A2 | 110,00 Hz | 9,09 ms |
| **6** | Mi | E2 | 82,40 Hz | 12,14 ms |

---

## 🔄 Feuille de Route & Stratégie Matérielle

Le développement suit deux phases distinctes :

### 🧪 Phase 1 : Prototypage, Simulation & Validation sur Carte Basys
* **Conception VHDL :** Architecture synchrone cadencée par l'horloge principale avec signaux de validation de cycle (*Clock Enable* - `CE`) pour éliminer tout *skew* d'horloge.
* **Simulation fonctionnelle :** Validation sous **ModelSim** à l'aide de testbenches dédiés.
* **Validation matérielle (FPGA Spartan-3E) :** 
  * Implémentation temporaire sur la carte de développement **Digilent Basys** (Spartan-3E XC3S100E).
  * Validation du bloc numérique en injectant un signal carré $0-3.3\text{ V}$ généré par un GBF sur les broches Pmod (ex: `J3`).

### 🛠️ Phase 2 : Carte Électronique Dédiée (PCB Final)
* **Routage PCB :** Conception d'un circuit imprimé sur mesure regroupant :
  * L'étage d'entrée analogique (Micro, AOP, Filtre, Trigger).
  * Le circuit logique numérique dédié (**CPLD** à très basse consommation et faible encombrement).
  * L'affichage (7-segments & LEDs du bargraphe).
  * La gestion de l'alimentation autonome (pile/batterie et régulateur ultra-low-power).
* **Migration FPGA vers CPLD :** Transfert de la logique VHDL validée sur FPGA vers la cible CPLD finale.

---

## 📁 Arborescence du Dépôt

```text
├── rtl/                        # Code source VHDL
│   ├── diviseur.vhd            # Générateur de fenêtre de mesure
│   ├── sequencer.vhd           # Machine à états (FSM)
│   ├── counter.vhd             # Compteur réversible
│   ├── register.vhd            # Registre de mémorisation
│   ├── display_controller.vhd  # Gestion afficheur et bargraphe
│   └── monoFrequency.vhd       # Top-level du cœur numérique
├── sim/                        # Testbenches et scripts ModelSim
│   ├── tb_monoFrequency.vhd    # Testbench du top-level
│   └── monoFrequency.do        # Script Tcl de compilation/simulation ModelSim
├── pcb/                        # Schématiques et fichiers KiCad / Altium (Phase 2)
│   ├── schematic/              # Schéma de la chaîne analogique et du CPLD
│   └── layout/                 # Routage du PCB
├── ucf/                        # Fichiers de contraintes de broches (Basys / CPLD)
└── README.md                   # Documentation du projet
```

---

## 💻 Simulation & Compilation

### 1. Simulation sous ModelSim
Pour exécuter la simulation complète depuis la racine du projet :
```bash
vsim -do sim/run.do
```
*(Le script Tcl `run.do` se charge de compiler les fichiers du dossier `rtl/` dans la bibliothèque `work`, de compiler les testbenches de `sim/` et de lancer la visualisation des chronogrammes).*

### 2. Synthèse sur carte de test Basys (Phase 1)
1. Ouvrir le projet dans **Xilinx ISE WebPack**.
2. Sélectionner la cible `Spartan3E - XC3S100E - TQ144`.
3. Générer le bitstream (`.bit`).
4. Charger sur la carte via **Digilent Adept**.
