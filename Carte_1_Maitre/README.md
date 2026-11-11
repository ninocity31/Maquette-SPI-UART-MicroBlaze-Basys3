# Carte 1 — Maître

- `vivado/` : block design (`design_1.bd`, script `design_1_bd.tcl`), wrapper de référence, `afficheur.vhd`, `pins.xdc` (identiques à la carte 2)
- `bitstream/` : export matériel `design_1_wrapper.hdf` (contient le bitstream), `.bit` et `.mmi`
- `sdk_src/` : `maitre.c` et `trame_spi.h`, à importer dans une *Empty Application* SDK

Rôle : passe l'AXI Quad SPI en maître, envoie une trame de 6 octets par pas de balayage (16 pas) et écrit `$RSSI,…` / `$BEST,…` sur l'UART à 9600 bauds. Voir le [README principal](../README.md).
