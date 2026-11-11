/******************************************************************************
 * maitre.c -- Carte MAITRE Basys 3 (MicroBlaze + AXI Quad SPI + UART + GPIO)
 * Maquette SPI / UART a deux cartes Basys 3
 *
 * Ce que fait le programme (simulation d'un balayage en 16 pas) :
 *   - 16 pas de balayage (angle -45 deg a +45 deg, pas de 6 deg) ;
 *   - a chaque pas, il envoie UNE trame SPI de 6 octets a l'esclave
 *     (cf. trame_spi.h) :
 *        LED      : position du faisceau (une seule LED allumee sur 16)
 *        gauche   : numero du pas (00 a 15, ecrit en decimal)
 *        droite   : |RSSI| simule (ecrit en decimal)
 *   - il affiche le meme etat sur ses propres LED / 7 segments
 *     (les deux cartes doivent donc montrer exactement la meme chose) ;
 *   - il envoie au PC, par l'UART (9600 bauds, 8N1), une ligne par pas :
 *        $RSSI,<pas>,<angle_deg>,<rssi_dBm>
 *     et une ligne de bilan par balayage :
 *        $BEST,<pas>,<angle_deg>,<rssi_dBm>,<err_spi>,<nack>
 *   - commandes recues du PC (un caractere) :
 *        p = pause, r = reprise, + = plus vite, - = plus lent
 *
 * Materiel (block design commun aux deux cartes) :
 *   AXI Quad SPI en mode Standard, "Enable Master Mode" DECOCHE :
 *   le mode maitre est choisi ici, par logiciel (XSP_MASTER_OPTION).
 *   GPIO canal 1 -> afficheur.vhd (HEX 16 bits), canal 2 -> 16 LED.
 *   spisel est tire a l'etat haut par le XDC (PULLUP) : pas de Mode Fault.
 ******************************************************************************/
#include "xparameters.h"
#include "xspi.h"
#include "xgpio.h"
#include "xuartlite_l.h"
#include "xil_printf.h"
#include "sleep.h"
#include "trame_spi.h"

/* ---- identifiants issus de xparameters.h (SDK 2019.1) ------------------- */
#define SPI_DEVICE_ID    XPAR_SPI_0_DEVICE_ID
#define GPIO_DEVICE_ID   XPAR_GPIO_0_DEVICE_ID
#define UART_BASEADDR    XPAR_UARTLITE_0_BASEADDR

#define GPIO_CANAL_AFF   1          /* canal 1 -> afficheur 7 segments */
#define GPIO_CANAL_LED   2          /* canal 2 -> 16 LED               */
#define SPI_ESCLAVE_0    0x01       /* bit 0 du registre SS -> ss_io[0] */

/* ---- balayage simule ----------------------------------------------------- */
#define N_PAS            16
#define ANGLE_DEBUT      (-45)
#define ANGLE_PAS        6
#define PAS_MS_DEFAUT    100        /* duree d'un pas */
#define PAS_MS_MIN       50         /* l'esclave a besoin de ~45 ms pour ses messages UART */
#define PAS_MS_MAX       1000

static XSpi  Spi;
static XGpio Gpio;

static u32 err_spi  = 0;            /* echecs de XSpi_Transfer          */
static u32 nack     = 0;            /* statuts d'erreur renvoyes par l'esclave */
static int pause    = 0;
static u32 pas_ms   = PAS_MS_DEFAUT;

/* ========================================================================= */
/*  Initialisations                                                          */
/* ========================================================================= */
static int init_spi(void)
{
    int st;

    st = XSpi_Initialize(&Spi, SPI_DEVICE_ID);
    if (st != XST_SUCCESS) { xil_printf("$ERR,SPI_INIT,%d\r\n", st); return st; }

    /* MASTER   : le bloc accepte maitre ET esclave, on choisit maitre ici.
     * MANUAL_SS: CS reste bas pendant les 6 octets (sinon il pourrait
     *            remonter entre deux octets si la FIFO se vide).
     * Pas d'option d'horloge -> mode 0 (CPOL = 0, CPHA = 0).               */
    st = XSpi_SetOptions(&Spi, XSP_MASTER_OPTION | XSP_MANUAL_SSELECT_OPTION);
    if (st != XST_SUCCESS) { xil_printf("$ERR,SPI_OPTIONS,%d\r\n", st); return st; }

    st = XSpi_SetSlaveSelect(&Spi, SPI_ESCLAVE_0);
    if (st != XST_SUCCESS) { xil_printf("$ERR,SPI_SS,%d\r\n", st); return st; }

    XSpi_Start(&Spi);
    XSpi_IntrGlobalDisable(&Spi);   /* pas d'interruptions : mode polling */
    return XST_SUCCESS;
}

static int init_gpio(void)
{
    int st = XGpio_Initialize(&Gpio, GPIO_DEVICE_ID);
    if (st != XST_SUCCESS) { xil_printf("$ERR,GPIO_INIT,%d\r\n", st); return st; }

    /* 0 = sortie pour chaque bit. Le canal 2 (LED) est relie a une
     * interface "board" a 3 etats : il faut le mettre en sortie.           */
    XGpio_SetDataDirection(&Gpio, GPIO_CANAL_AFF, 0x0000);
    XGpio_SetDataDirection(&Gpio, GPIO_CANAL_LED, 0x0000);
    XGpio_DiscreteWrite(&Gpio, GPIO_CANAL_AFF, 0x0000);
    XGpio_DiscreteWrite(&Gpio, GPIO_CANAL_LED, 0x0000);
    return XST_SUCCESS;
}

/* ========================================================================= */
/*  Envoi d'une trame                                                        */
/* ========================================================================= */
/* Envoie 6 octets. rx recoit ce que l'esclave renvoie sur MISO :
 * rx[0] = statut de la trame PRECEDENTE (STATUT_OK si tout va bien).       */
static int spi_envoyer_trame(const u8 *tx, u8 *rx)
{
    /* XSpi_Transfer : met SS a 0, envoie les 6 octets, attend la fin,
     * remet SS a 1. Le buffer d'emission doit etre modifiable (u8 *).       */
    u8 copie[TRAME_LONGUEUR];
    for (int i = 0; i < TRAME_LONGUEUR; i++) copie[i] = tx[i];

    int st = XSpi_Transfer(&Spi, copie, rx, TRAME_LONGUEUR);
    if (st != XST_SUCCESS) err_spi++;
    return st;
}

/* Le maitre affiche le meme etat que celui qu'il envoie a l'esclave */
static void afficher_local(u16 leds, u8 aff_g, u8 aff_d)
{
    XGpio_DiscreteWrite(&Gpio, GPIO_CANAL_LED, leds);
    XGpio_DiscreteWrite(&Gpio, GPIO_CANAL_AFF, ((u32)aff_g << 8) | aff_d);
}

/* ========================================================================= */
/*  Outils                                                                   */
/* ========================================================================= */
/* 0..99 -> BCD : 42 -> 0x42, pour que l'afficheur hexa montre "42" */
static u8 en_bcd(int v)
{
    if (v < 0)  v = -v;
    if (v > 99) v = 99;
    return (u8)(((v / 10) << 4) | (v % 10));
}

/* Bruit pseudo-aleatoire dans [-amp, +amp] (generateur congruentiel) */
static u32 graine = 12345;
static int bruit(int amp)
{
    graine = graine * 1103515245u + 12345u;
    return (int)((graine >> 16) % (u32)(2 * amp + 1)) - amp;
}

/* RSSI simule : maximum quand le pas courant est sur la "cible" */
static int rssi_simule(int pas, int cible)
{
    int d = (pas > cible) ? pas - cible : cible - pas;
    int r = -40 - 4 * d + bruit(2);
    return (r < -99) ? -99 : r;
}

/* Lecture non bloquante des commandes du PC */
static void lire_commandes_pc(void)
{
    while (!XUartLite_IsReceiveEmpty(UART_BASEADDR)) {
        u8 c = XUartLite_RecvByte(UART_BASEADDR);
        switch (c) {
        case 'p': pause = 1; xil_printf("$ACK,PAUSE\r\n"); break;
        case 'r': pause = 0; xil_printf("$ACK,RUN\r\n");   break;
        case '+': if (pas_ms / 2 >= PAS_MS_MIN) pas_ms /= 2;
                  xil_printf("$ACK,PAS_MS,%d\r\n", (int)pas_ms); break;
        case '-': if (pas_ms * 2 <= PAS_MS_MAX) pas_ms *= 2;
                  xil_printf("$ACK,PAS_MS,%d\r\n", (int)pas_ms); break;
        default:  break;
        }
    }
}

/* ========================================================================= */
int main(void)
{
    u8 tx[TRAME_LONGUEUR], rx[TRAME_LONGUEUR];
    int cible = 5, sens = 1;               /* position simulee de la cible */

    xil_printf("\r\n$INFO,MAQUETTE maitre SPI/UART demarre\r\n");

    if (init_gpio() != XST_SUCCESS || init_spi() != XST_SUCCESS) {
        xil_printf("$ERR,INIT -> arret\r\n");
        while (1);
    }
    xil_printf("$INFO,SPI maitre OK, SCK = 100 MHz / 80 = 1,25 MHz\r\n");

    while (1) {
        int meilleur_pas = 0, meilleur_rssi = -127;

        for (int k = 0; k < N_PAS; k++) {
            lire_commandes_pc();
            while (pause) lire_commandes_pc();

            int angle = ANGLE_DEBUT + k * ANGLE_PAS;
            int rssi  = rssi_simule(k, cible);

            /* 1) consigne de "depointage" -> esclave */
            u16 leds  = (u16)(1u << k);
            u8  aff_g = en_bcd(k);
            u8  aff_d = en_bcd(rssi);
            trame_construire(tx, leds, aff_g, aff_d);

            if (spi_envoyer_trame(tx, rx) == XST_SUCCESS && rx[0] != STATUT_OK)
                nack++;                     /* l'esclave a rejete la trame precedente */

            afficher_local(leds, aff_g, aff_d);

            /* 2) mesure -> IHM */
            xil_printf("$RSSI,%d,%d,%d\r\n", k, angle, rssi);

            if (rssi > meilleur_rssi) { meilleur_rssi = rssi; meilleur_pas = k; }
            usleep(pas_ms * 1000);
        }

        xil_printf("$BEST,%d,%d,%d,%d,%d\r\n",
                   meilleur_pas, ANGLE_DEBUT + meilleur_pas * ANGLE_PAS,
                   meilleur_rssi, (int)err_spi, (int)nack);

        /* la "cible" se deplace d'un pas par balayage, entre 2 et 13 */
        cible += sens;
        if (cible >= 13 || cible <= 2) sens = -sens;
    }
    return 0;
}
