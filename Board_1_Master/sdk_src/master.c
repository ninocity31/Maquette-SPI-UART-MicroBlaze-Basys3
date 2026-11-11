/******************************************************************************
 * master.c -- Board 1 (master): MicroBlaze + AXI Quad SPI + UART Lite + GPIO
 *
 * - Every step (100 ms) it increments a counter and sends it to the slave
 *   in one 6-byte SPI frame (see spi_frame.h):
 *       LEDs    : counter in binary (16 bits)
 *       display : counter in decimal (0000..9999, BCD coded)
 * - Its own display stays fixed on "1111" (LEDs off).
 * - It simulates a 16-step scan (-45..+45 deg) and sends to the PC over
 *   UART (9600 baud, 8N1):
 *       $RSSI,<step>,<angle_deg>,<rssi_dBm>            one line per step
 *       $BEST,<step>,<angle_deg>,<rssi_dBm>,<err>,<nack> one line per scan
 * - PC commands (one character): p = pause, r = run, + = faster, - = slower
 *
 * The AXI Quad SPI is built with "Enable Master Mode" unchecked, so it can be
 * master or slave: master mode is selected here by software.
 ******************************************************************************/
#include "xparameters.h"
#include "xspi.h"
#include "xgpio.h"
#include "xuartlite_l.h"
#include "xil_printf.h"
#include "sleep.h"
#include "spi_frame.h"

#define SPI_DEVICE_ID    XPAR_SPI_0_DEVICE_ID
#define GPIO_DEVICE_ID   XPAR_GPIO_0_DEVICE_ID
#define UART_BASEADDR    XPAR_UARTLITE_0_BASEADDR

#define GPIO_CH_DISPLAY  1          /* channel 1 -> afficheur.vhd (HEX) */
#define GPIO_CH_LEDS     2          /* channel 2 -> 16 LEDs             */
#define SPI_SLAVE_0      0x01       /* bit 0 of SS register -> ss_io[0] */

#define N_STEPS          16
#define ANGLE_START      (-45)
#define ANGLE_STEP       6
#define STEP_MS_DEFAULT  100
#define STEP_MS_MIN      50         /* slave needs ~45 ms for its UART messages */
#define STEP_MS_MAX      1000

static XSpi  Spi;
static XGpio Gpio;

static u32 err_spi = 0;             /* failed XSpi_Transfer calls          */
static u32 nack    = 0;             /* error statuses returned by the slave */
static int paused  = 0;
static u32 step_ms = STEP_MS_DEFAULT;
static u16 counter = 0;             /* value sent to the slave              */

/* ------------------------------------------------------------------------- */
static int spi_init(void)
{
    int st = XSpi_Initialize(&Spi, SPI_DEVICE_ID);
    if (st != XST_SUCCESS) { xil_printf("$ERR,SPI_INIT,%d\r\n", st); return st; }

    /* MASTER: select master mode. MANUAL_SS: keep CS low for all 6 bytes.
     * No clock option -> SPI mode 0 (CPOL = 0, CPHA = 0).                  */
    st = XSpi_SetOptions(&Spi, XSP_MASTER_OPTION | XSP_MANUAL_SSELECT_OPTION);
    if (st != XST_SUCCESS) { xil_printf("$ERR,SPI_OPTIONS,%d\r\n", st); return st; }

    st = XSpi_SetSlaveSelect(&Spi, SPI_SLAVE_0);
    if (st != XST_SUCCESS) { xil_printf("$ERR,SPI_SS,%d\r\n", st); return st; }

    XSpi_Start(&Spi);
    XSpi_IntrGlobalDisable(&Spi);   /* polled mode */
    return XST_SUCCESS;
}

static int gpio_init(void)
{
    int st = XGpio_Initialize(&Gpio, GPIO_DEVICE_ID);
    if (st != XST_SUCCESS) { xil_printf("$ERR,GPIO_INIT,%d\r\n", st); return st; }
    XGpio_SetDataDirection(&Gpio, GPIO_CH_DISPLAY, 0x0000);   /* 0 = output */
    XGpio_SetDataDirection(&Gpio, GPIO_CH_LEDS,    0x0000);
    XGpio_DiscreteWrite(&Gpio, GPIO_CH_DISPLAY, 0x0000);
    XGpio_DiscreteWrite(&Gpio, GPIO_CH_LEDS,    0x0000);
    return XST_SUCCESS;
}

/* Send one 6-byte frame. rx[0] = status of the PREVIOUS frame from the slave */
static int spi_send_frame(const u8 *tx, u8 *rx)
{
    u8 buf[FRAME_LENGTH];
    for (int i = 0; i < FRAME_LENGTH; i++) buf[i] = tx[i];   /* driver needs a writable buffer */
    int st = XSpi_Transfer(&Spi, buf, rx, FRAME_LENGTH);     /* CS low, 6 bytes, CS high */
    if (st != XST_SUCCESS) err_spi++;
    return st;
}

/* 0..99 -> BCD (42 -> 0x42) so the hex display shows decimal digits */
static u8 to_bcd(int v)
{
    if (v < 0)  v = -v;
    if (v > 99) v = 99;
    return (u8)(((v / 10) << 4) | (v % 10));
}

/* Pseudo-random noise in [-amp, +amp] */
static u32 seed = 12345;
static int noise(int amp)
{
    seed = seed * 1103515245u + 12345u;
    return (int)((seed >> 16) % (u32)(2 * amp + 1)) - amp;
}

/* Simulated RSSI: maximum when the step is on the target */
static int rssi_sim(int step, int target)
{
    int d = (step > target) ? step - target : target - step;
    int r = -40 - 4 * d + noise(2);
    return (r < -99) ? -99 : r;
}

/* Non-blocking read of PC commands */
static void read_pc_commands(void)
{
    while (!XUartLite_IsReceiveEmpty(UART_BASEADDR)) {
        u8 c = XUartLite_RecvByte(UART_BASEADDR);
        switch (c) {
        case 'p': paused = 1; xil_printf("$ACK,PAUSE\r\n"); break;
        case 'r': paused = 0; xil_printf("$ACK,RUN\r\n");   break;
        case '+': if (step_ms / 2 >= STEP_MS_MIN) step_ms /= 2;
                  xil_printf("$ACK,STEP_MS,%d\r\n", (int)step_ms); break;
        case '-': if (step_ms * 2 <= STEP_MS_MAX) step_ms *= 2;
                  xil_printf("$ACK,STEP_MS,%d\r\n", (int)step_ms); break;
        default:  break;
        }
    }
}

/* ------------------------------------------------------------------------- */
int main(void)
{
    u8 tx[FRAME_LENGTH], rx[FRAME_LENGTH];
    int target = 5, dir = 1;               /* simulated target position */

    xil_printf("\r\n$INFO,master SPI/UART started\r\n");

    if (gpio_init() != XST_SUCCESS) { xil_printf("$ERR,GPIO init -> stop\r\n"); while (1); }

    /* Start-up signature of board 1: "1111" + all LEDs for 1 s,
     * then "1111" stays and the LEDs go off.                    */
    XGpio_DiscreteWrite(&Gpio, GPIO_CH_DISPLAY, 0x1111);
    XGpio_DiscreteWrite(&Gpio, GPIO_CH_LEDS,    0xFFFF);
    xil_printf("$INFO,board 1 (master) signature: 1111 + 16 LEDs\r\n");
    usleep(1000000);
    XGpio_DiscreteWrite(&Gpio, GPIO_CH_LEDS, 0x0000);

    if (spi_init() != XST_SUCCESS) { xil_printf("$ERR,SPI init -> stop\r\n"); while (1); }
    xil_printf("$INFO,SPI master OK, SCK = 100 MHz / 80 = 1.25 MHz\r\n");

    while (1) {
        int best_step = 0, best_rssi = -127;

        for (int k = 0; k < N_STEPS; k++) {
            read_pc_commands();
            while (paused) read_pc_commands();

            int angle = ANGLE_START + k * ANGLE_STEP;
            int rssi  = rssi_sim(k, target);

            /* 1) counter -> slave: LEDs in binary, display in decimal */
            counter++;
            frame_build(tx, counter,
                        to_bcd((counter / 100) % 100),     /* thousands, hundreds */
                        to_bcd(counter % 100));            /* tens, units         */
            if (spi_send_frame(tx, rx) == XST_SUCCESS && rx[0] != STATUS_OK)
                nack++;                                    /* slave rejected previous frame */

            /* 2) measurement -> PC */
            xil_printf("$RSSI,%d,%d,%d\r\n", k, angle, rssi);
            if (rssi > best_rssi) { best_rssi = rssi; best_step = k; }

            usleep(step_ms * 1000);
        }

        xil_printf("$BEST,%d,%d,%d,%d,%d\r\n", best_step,
                   ANGLE_START + best_step * ANGLE_STEP, best_rssi,
                   (int)err_spi, (int)nack);

        target += dir;                     /* target moves one step per scan */
        if (target >= 13 || target <= 2) dir = -dir;
    }
    return 0;
}
