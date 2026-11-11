/******************************************************************************
 * slave.c -- Board 2 (slave): same bitstream as the master
 *
 * Receives the SPI frames of the master (see spi_frame.h) and, at the end of
 * each valid frame, writes the LEDs and the 7-segment display. The new value
 * is applied only when CS goes back high (latch behaviour).
 *
 * - AXI Quad SPI set to SLAVE by software (no MASTER option);
 * - the master's CS arrives on spisel (JA7);
 * - frame start/end is detected with the "Slave Mode Select" bit of SPISR
 *   (bit 5: 0 = selected by the master, 1 = idle);
 * - the status of each frame is put in the TX FIFO and returned on MISO
 *   during the next frame;
 * - UART (9600 baud): one $STAT line every 16 frames, one $ERR line per error.
 *   Lines are printed right after a frame, while the master is idle.
 ******************************************************************************/
#include "xparameters.h"
#include "xspi.h"
#include "xspi_l.h"
#include "xgpio.h"
#include "xil_printf.h"
#include "spi_frame.h"

#define SPI_DEVICE_ID    XPAR_SPI_0_DEVICE_ID
#define GPIO_DEVICE_ID   XPAR_GPIO_0_DEVICE_ID
#define GPIO_CH_DISPLAY  1
#define GPIO_CH_LEDS     2

#define BUF_SIZE         32          /* > FIFO depth (16) */
#define STAT_EVERY       16          /* one $STAT line every 16 valid frames */

static XSpi  Spi;
static XGpio Gpio;
static UINTPTR spi_base;

static u32 n_ok = 0, n_err_len = 0, n_err_sync = 0, n_err_chk = 0;

/* ------------------------------------------------------------------------- */
static int gpio_init(void)
{
    int st = XGpio_Initialize(&Gpio, GPIO_DEVICE_ID);
    if (st != XST_SUCCESS) return st;
    XGpio_SetDataDirection(&Gpio, GPIO_CH_DISPLAY, 0x0000);
    XGpio_SetDataDirection(&Gpio, GPIO_CH_LEDS,    0x0000);
    return XST_SUCCESS;
}

static int spi_slave_init(void)
{
    int st = XSpi_Initialize(&Spi, SPI_DEVICE_ID);
    if (st != XST_SUCCESS) return st;
    st = XSpi_SetOptions(&Spi, 0);   /* no option: SLAVE, mode 0, MSB first */
    if (st != XST_SUCCESS) return st;
    XSpi_Start(&Spi);                /* enable the core, reset the FIFOs */
    XSpi_IntrGlobalDisable(&Spi);    /* polled mode */
    spi_base = Spi.BaseAddr;
    return XST_SUCCESS;
}

/* 1 while the master holds CS (spisel) low */
static inline int is_selected(void)
{
    return (XSpi_ReadReg(spi_base, XSP_SR_OFFSET) & XSP_SR_SLAVE_MODE_MASK) == 0;
}

/* Empty the RX FIFO into buf[n..]; returns the new byte count */
static u32 read_rx_fifo(u8 *buf, u32 n)
{
    while ((XSpi_ReadReg(spi_base, XSP_SR_OFFSET) & XSP_SR_RX_EMPTY_MASK) == 0) {
        u8 b = (u8)XSpi_ReadReg(spi_base, XSP_DRR_OFFSET);
        if (n < BUF_SIZE) buf[n] = b;
        n++;
    }
    return n;
}

/* Prepare what the master will read on MISO during the next frame */
static void prepare_reply(u8 status)
{
    u32 cr = XSpi_ReadReg(spi_base, XSP_CR_OFFSET);
    XSpi_WriteReg(spi_base, XSP_CR_OFFSET, cr | XSP_CR_TXFIFO_RESET_MASK);
    XSpi_WriteReg(spi_base, XSP_DTR_OFFSET, status);
    for (int i = 1; i < FRAME_LENGTH; i++)
        XSpi_WriteReg(spi_base, XSP_DTR_OFFSET, 0x00);
}

static void print_hex(const u8 *f, u32 n)
{
    for (u32 i = 0; i < n && i < BUF_SIZE; i++) xil_printf(" %02X", f[i]);
    xil_printf("\r\n");
}

/* Check and apply a complete frame (called when CS goes high) */
static void process_frame(const u8 *f, u32 n)
{
    u8 status;

    if (n != FRAME_LENGTH) {
        status = STATUS_ERR_LEN;  n_err_len++;
        xil_printf("$ERR,LEN,%d bytes:", (int)n);  print_hex(f, n);
    } else if (f[IDX_SYNC] != FRAME_SYNC) {
        status = STATUS_ERR_SYNC; n_err_sync++;
        xil_printf("$ERR,SYNC:");  print_hex(f, n);
    } else if (f[IDX_CHK] != frame_chk(f)) {
        status = STATUS_ERR_CHK;  n_err_chk++;
        xil_printf("$ERR,CHK:");   print_hex(f, n);
    } else {
        XGpio_DiscreteWrite(&Gpio, GPIO_CH_LEDS,
                            ((u32)f[IDX_LED_HI] << 8) | f[IDX_LED_LO]);
        XGpio_DiscreteWrite(&Gpio, GPIO_CH_DISPLAY,
                            ((u32)f[IDX_SEG_L] << 8) | f[IDX_SEG_R]);
        status = STATUS_OK;
        n_ok++;
        if (n_ok % STAT_EVERY == 0)
            xil_printf("$STAT,ok=%d,len=%d,sync=%d,chk=%d\r\n", (int)n_ok,
                       (int)n_err_len, (int)n_err_sync, (int)n_err_chk);
    }
    prepare_reply(status);
}

/* ------------------------------------------------------------------------- */
int main(void)
{
    u8  buf[BUF_SIZE];
    u32 n = 0;
    int was_selected = 0;

    xil_printf("\r\n$INFO,slave SPI started\r\n");

    if (gpio_init() != XST_SUCCESS) { xil_printf("$ERR,GPIO init -> stop\r\n"); while (1); }

    /* Start-up signature of board 2: "2222" + every other LED,
     * kept until the first valid frame is received.            */
    XGpio_DiscreteWrite(&Gpio, GPIO_CH_DISPLAY, 0x2222);
    XGpio_DiscreteWrite(&Gpio, GPIO_CH_LEDS,    0x5555);
    xil_printf("$INFO,board 2 (slave) signature: 2222 + every other LED\r\n");

    if (spi_slave_init() != XST_SUCCESS) { xil_printf("$ERR,SPI init -> stop\r\n"); while (1); }
    (void)read_rx_fifo(buf, 0);      /* drop anything already received */
    prepare_reply(STATUS_OK);
    xil_printf("$INFO,SPI slave ready, waiting for frames\r\n");

    while (1) {
        /* Read CS BEFORE emptying the FIFO: if CS is seen high, the last
         * byte of the frame is already in the FIFO and is read just after. */
        int selected = is_selected();
        n = read_rx_fifo(buf, n);

        if (was_selected && !selected) {     /* CS rising edge = end of frame */
            n = read_rx_fifo(buf, n);
            process_frame(buf, n);
            n = 0;
        }
        was_selected = selected;
    }
    return 0;
}
