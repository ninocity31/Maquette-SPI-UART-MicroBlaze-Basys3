/******************************************************************************
 * esclave.c -- Carte ESCLAVE Basys 3 (meme bitstream que le maitre)
 * Maquette SPI / UART a deux cartes Basys 3
 *
 * Role : jouer un peripherique pilote en SPI. Elle recoit les trames SPI du
 * maitre (cf. trame_spi.h) et, a la fin de chaque trame valide, met a jour
 * ses 16 LED et ses deux afficheurs. Comme un registre a verrou, elle n'applique la
 * nouvelle consigne qu'a la REMONTEE de CS.
 *
 * Fonctionnement :
 *   - AXI Quad SPI configure en ESCLAVE par logiciel (pas d'option MASTER) ;
 *   - le CS du maitre arrive sur spisel (JA7) ;
 *   - le programme surveille le bit "Slave Mode Select" du registre d'etat
 *     (SPISR bit 5 : 0 = selectionne par le maitre, 1 = libre) pour reperer
 *     le debut et la fin de chaque trame, et vide la FIFO de reception ;
 *   - a la fin de la trame : controle longueur / SYNC / CHK, puis application ;
 *   - il prepare dans la FIFO d'emission le statut a renvoyer sur MISO
 *     pendant la trame suivante ;
 *   - UART (9600 bauds) : bilan toutes les 16 trames, et un message a
 *     chaque erreur. Les messages sont envoyes juste apres une trame, quand
 *     le maitre ne transmet pas (il laisse au moins 50 ms entre deux trames).
 ******************************************************************************/
#include "xparameters.h"
#include "xspi.h"
#include "xspi_l.h"
#include "xgpio.h"
#include "xil_printf.h"
#include "trame_spi.h"

#define SPI_DEVICE_ID    XPAR_SPI_0_DEVICE_ID
#define GPIO_DEVICE_ID   XPAR_GPIO_0_DEVICE_ID
#define GPIO_CANAL_AFF   1
#define GPIO_CANAL_LED   2

#define TAILLE_TAMPON    32          /* > profondeur FIFO (16) */
#define BILAN_TOUTES     16          /* un bilan UART toutes les 16 trames OK */

static XSpi  Spi;
static XGpio Gpio;
static UINTPTR spi_base;

static u32 nb_ok = 0, nb_err_long = 0, nb_err_sync = 0, nb_err_chk = 0;

/* ========================================================================= */
/*  Initialisations                                                          */
/* ========================================================================= */
static int init_gpio(void)
{
    int st = XGpio_Initialize(&Gpio, GPIO_DEVICE_ID);
    if (st != XST_SUCCESS) return st;
    XGpio_SetDataDirection(&Gpio, GPIO_CANAL_AFF, 0x0000);
    XGpio_SetDataDirection(&Gpio, GPIO_CANAL_LED, 0x0000);
    XGpio_DiscreteWrite(&Gpio, GPIO_CANAL_AFF, 0x0000);
    XGpio_DiscreteWrite(&Gpio, GPIO_CANAL_LED, 0x0000);
    return XST_SUCCESS;
}

static int init_spi_esclave(void)
{
    int st = XSpi_Initialize(&Spi, SPI_DEVICE_ID);
    if (st != XST_SUCCESS) return st;

    /* Aucune option : ESCLAVE, mode 0 (CPOL = 0, CPHA = 0), MSB en premier */
    st = XSpi_SetOptions(&Spi, 0);
    if (st != XST_SUCCESS) return st;

    XSpi_Start(&Spi);                /* active le bloc et vide les FIFO */
    XSpi_IntrGlobalDisable(&Spi);    /* mode polling */
    spi_base = Spi.BaseAddr;
    return XST_SUCCESS;
}

/* ========================================================================= */
/*  Acces bas niveau au bloc SPI                                             */
/* ========================================================================= */
/* 1 si le maitre a baisse CS (spisel = 0) */
static inline int est_selectionne(void)
{
    return (XSpi_ReadReg(spi_base, XSP_SR_OFFSET) & XSP_SR_SLAVE_MODE_MASK) == 0;
}

/* Vide la FIFO de reception dans tampon[n..] ; renvoie le nouveau compte.
 * Les octets en trop sont comptes mais pas memorises.                     */
static u32 lire_fifo_rx(u8 *tampon, u32 n)
{
    while ((XSpi_ReadReg(spi_base, XSP_SR_OFFSET) & XSP_SR_RX_EMPTY_MASK) == 0) {
        u8 octet = (u8)XSpi_ReadReg(spi_base, XSP_DRR_OFFSET);
        if (n < TAILLE_TAMPON) tampon[n] = octet;
        n++;
    }
    return n;
}

/* Prepare ce que le maitre lira sur MISO pendant la trame suivante :
 * octet 0 = statut de la trame qui vient d'etre recue, puis des zeros.    */
static void preparer_reponse(u8 statut)
{
    u32 cr = XSpi_ReadReg(spi_base, XSP_CR_OFFSET);
    XSpi_WriteReg(spi_base, XSP_CR_OFFSET, cr | XSP_CR_TXFIFO_RESET_MASK);
    XSpi_WriteReg(spi_base, XSP_DTR_OFFSET, statut);
    for (int i = 1; i < TRAME_LONGUEUR; i++)
        XSpi_WriteReg(spi_base, XSP_DTR_OFFSET, 0x00);
}

/* ========================================================================= */
/*  Traitement d'une trame complete (appele a la remontee de CS)             */
/* ========================================================================= */
static void afficher_hexa(const u8 *t, u32 n)
{
    for (u32 i = 0; i < n && i < TAILLE_TAMPON; i++) xil_printf(" %02X", t[i]);
    xil_printf("\r\n");
}

static void traiter_trame(const u8 *t, u32 n)
{
    u8 statut;

    if (n != TRAME_LONGUEUR) {
        statut = STATUT_ERR_LONG;  nb_err_long++;
        xil_printf("$ERR,LONG,%d octets :", (int)n);  afficher_hexa(t, n);
    } else if (t[IDX_SYNC] != TRAME_SYNC) {
        statut = STATUT_ERR_SYNC;  nb_err_sync++;
        xil_printf("$ERR,SYNC :");  afficher_hexa(t, n);
    } else if (t[IDX_CHK] != trame_chk(t)) {
        statut = STATUT_ERR_CHK;   nb_err_chk++;
        xil_printf("$ERR,CHK :");   afficher_hexa(t, n);
    } else {
        /* trame valide : application (= "latch" a la remontee de CS) */
        u16 leds = (u16)(((u16)t[IDX_LED_HI] << 8) | t[IDX_LED_LO]);
        u32 hex  = ((u32)t[IDX_AFF_G] << 8) | t[IDX_AFF_D];
        XGpio_DiscreteWrite(&Gpio, GPIO_CANAL_LED, leds);
        XGpio_DiscreteWrite(&Gpio, GPIO_CANAL_AFF, hex);
        statut = STATUT_OK;
        nb_ok++;
        if (nb_ok % BILAN_TOUTES == 0)
            xil_printf("$STAT,ok=%d,long=%d,sync=%d,chk=%d\r\n", (int)nb_ok,
                       (int)nb_err_long, (int)nb_err_sync, (int)nb_err_chk);
    }
    preparer_reponse(statut);
}

/* ========================================================================= */
int main(void)
{
    u8  tampon[TAILLE_TAMPON];
    u32 n = 0;
    int selection_prec = 0;

    xil_printf("\r\n$INFO,MAQUETTE esclave SPI demarre\r\n");

    if (init_gpio() != XST_SUCCESS) {
        xil_printf("$ERR,INIT GPIO -> arret\r\n");
        while (1);
    }

    /* Signature de demarrage de la CARTE 2 (esclave) : "2222" sur l'afficheur
     * et une LED sur deux. Elle reste visible jusqu'a la premiere trame
     * valide recue du maitre.                                               */
    XGpio_DiscreteWrite(&Gpio, GPIO_CANAL_AFF, 0x2222);
    XGpio_DiscreteWrite(&Gpio, GPIO_CANAL_LED, 0x5555);
    xil_printf("$INFO,signature carte 2 (esclave) : 2222 + LED une sur deux\r\n");

    if (init_spi_esclave() != XST_SUCCESS) {
        xil_printf("$ERR,INIT SPI -> arret\r\n");
        while (1);
    }
    n = lire_fifo_rx(tampon, 0);     /* on jette ce qui serait deja la */
    n = 0;
    preparer_reponse(STATUT_OK);
    xil_printf("$INFO,SPI esclave pret, en attente de trames\r\n");

    while (1) {
        /* Ordre important : lire l'etat de CS AVANT de vider la FIFO.
         * Ainsi, si CS est vu remonte, le dernier octet de la trame est
         * forcement deja dans la FIFO et il sera lu juste apres.          */
        int selection = est_selectionne();
        n = lire_fifo_rx(tampon, n);

        if (selection_prec && !selection) {     /* front montant de CS */
            n = lire_fifo_rx(tampon, n);
            traiter_trame(tampon, n);
            n = 0;
        }
        selection_prec = selection;
    }
    return 0;
}
