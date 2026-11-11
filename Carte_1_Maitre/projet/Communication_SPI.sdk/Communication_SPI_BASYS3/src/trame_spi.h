/******************************************************************************
 * trame_spi.h -- Protocole SPI maitre -> esclave (maquette a deux Basys 3)
 *
 * Ce fichier est le "contrat" entre les deux cartes : il doit etre IDENTIQUE
 * dans le projet du maitre et dans celui de l'esclave.
 *
 * Une trame = 6 octets envoyes pendant UN seul passage de CS a l'etat bas,
 * en SPI mode 0 (CPOL = 0, CPHA = 0), MSB en premier :
 *
 *   octet 0 : SYNC    = 0xA5 (fixe)
 *   octet 1 : LED_LO  = LED 7..0   (bit 0 = LED0)
 *   octet 2 : LED_HI  = LED 15..8  (bit 0 = LED8)
 *   octet 3 : AFF_G   = afficheur gauche (digits 3-2) -> HEX(15:8)
 *   octet 4 : AFF_D   = afficheur droit  (digits 1-0) -> HEX(7:0)
 *   octet 5 : CHK     = LED_LO ^ LED_HI ^ AFF_G ^ AFF_D
 *
 * Exemple : LED0, LED7, LED10..13, "12" a gauche, "AB" a droite
 *           -> A5 81 3C 12 AB 04
 *
 * Regle de l'esclave : la trame n'est appliquee qu'a la REMONTEE de CS, et
 * seulement si elle fait exactement 6 octets, commence par 0xA5 et a un CHK
 * juste. Sinon elle est ignoree et l'etat precedent est conserve.
 *
 * Reponse de l'esclave (sur MISO, pendant la trame SUIVANTE) : le premier
 * octet renvoye est le statut de la trame precedente (STATUT_xxx ci-dessous).
 ******************************************************************************/
#ifndef TRAME_SPI_H
#define TRAME_SPI_H

#include "xil_types.h"

#define TRAME_SYNC       0xA5
#define TRAME_LONGUEUR   6

/* position de chaque champ dans la trame */
#define IDX_SYNC         0
#define IDX_LED_LO       1
#define IDX_LED_HI       2
#define IDX_AFF_G        3
#define IDX_AFF_D        4
#define IDX_CHK          5

/* statut renvoye par l'esclave sur MISO */
#define STATUT_OK        0x00
#define STATUT_ERR_LONG  0xE1   /* nombre d'octets different de 6 */
#define STATUT_ERR_SYNC  0xE2   /* premier octet different de 0xA5 */
#define STATUT_ERR_CHK   0xE3   /* checksum faux */

/* Calcul du CHK : XOR des 4 octets de donnees (le SYNC n'est pas inclus) */
static inline u8 trame_chk(const u8 *t)
{
    return (u8)(t[IDX_LED_LO] ^ t[IDX_LED_HI] ^ t[IDX_AFF_G] ^ t[IDX_AFF_D]);
}

/* Remplit t[0..5] a partir de l'etat voulu */
static inline void trame_construire(u8 *t, u16 leds, u8 aff_g, u8 aff_d)
{
    t[IDX_SYNC]   = TRAME_SYNC;
    t[IDX_LED_LO] = (u8)(leds & 0xFF);
    t[IDX_LED_HI] = (u8)(leds >> 8);
    t[IDX_AFF_G]  = aff_g;
    t[IDX_AFF_D]  = aff_d;
    t[IDX_CHK]    = trame_chk(t);
}

#endif /* TRAME_SPI_H */
