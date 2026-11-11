# Carte 2 — Esclave

- `projet/` : **projet complet** Vivado (`Communication_SPI.xpr`) et SDK (`Communication_SPI.sdk/`, application avec `esclave.c`) — voir « Option 1 » du README principal
- `vivado/` : mêmes sources que la carte 1 (le bitstream est commun aux deux cartes)
- `bitstream/` : même export matériel que la carte 1
- `sdk_src/` : `esclave.c` et `trame_spi.h`, à importer dans une seconde *Empty Application* SDK

Rôle : configure l'AXI Quad SPI en esclave, repère chaque trame grâce au bit *Slave Mode Select* de SPISR, la contrôle (longueur, SYNC, CHK) et l'applique sur les LED et les afficheurs à la remontée de CS. Le CS du maître arrive sur `spisel` (JA7). Voir le [README principal](../README.md).
