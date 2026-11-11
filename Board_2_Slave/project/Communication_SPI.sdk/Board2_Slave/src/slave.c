/*
 * slave.c  -  Board 2 (slave)
 *
 * What this program does:
 *   1. Shows "2222" on the display (to recognise board 2).
 *   2. Waits for SPI frames from board 1.
 *   3. When a frame is complete and correct, shows the counter:
 *        - on the 16 LEDs (in binary),
 *        - on the display (in decimal).
 */

#include "xparameters.h"
#include "xspi.h"
#include "xgpio.h"
#include "spi_frame.h"

/* Registers of the SPI block (offsets from its base address) */
#define SPI_STATUS_REG    0x64    /* status register              */
#define SPI_RX_DATA_REG   0x6C    /* received data (one byte)     */
#define RX_EMPTY          0x01    /* status bit: nothing received */
#define NOT_SELECTED      0x20    /* status bit: CS is high       */

XSpi  spi;      /* the SPI block  */
XGpio gpio;     /* the GPIO block (channel 1 = display, channel 2 = LEDs) */

int main(void)
{
    u8  frame[FRAME_SIZE];   /* received bytes */
    int count;               /* number of bytes received */
    u32 status;
    u8  byte;
    u8  checksum;

    /* ---------- 1. GPIO: LEDs and display ---------- */
    XGpio_Initialize(&gpio, XPAR_GPIO_0_DEVICE_ID);
    XGpio_SetDataDirection(&gpio, 1, 0x0000);   /* channel 1 = outputs */
    XGpio_SetDataDirection(&gpio, 2, 0x0000);   /* channel 2 = outputs */

    /* Signature of board 2: "2222" and every other LED */
    XGpio_DiscreteWrite(&gpio, 1, 0x2222);
    XGpio_DiscreteWrite(&gpio, 2, 0x5555);

    /* ---------- 2. SPI in slave mode ---------- */
    XSpi_Initialize(&spi, XPAR_SPI_0_DEVICE_ID);
    XSpi_SetOptions(&spi, 0);                   /* no option = slave */
    XSpi_Start(&spi);
    XSpi_IntrGlobalDisable(&spi);               /* no interrupts */

    /* ---------- 3. Main loop ---------- */
    while (1) {

        /* Wait until board 1 sets CS low (start of a frame) */
        do {
            status = XSpi_ReadReg(spi.BaseAddr, SPI_STATUS_REG);
        } while (status & NOT_SELECTED);

        /* Read the bytes while CS is low */
        count = 0;
        do {
            status = XSpi_ReadReg(spi.BaseAddr, SPI_STATUS_REG);
            while ((XSpi_ReadReg(spi.BaseAddr, SPI_STATUS_REG) & RX_EMPTY) == 0) {
                byte = XSpi_ReadReg(spi.BaseAddr, SPI_RX_DATA_REG);
                if (count < FRAME_SIZE) {
                    frame[count] = byte;
                }
                count = count + 1;
            }
        } while ((status & NOT_SELECTED) == 0);   /* until CS goes high */

        /* The frame is finished: check it */
        if (count != FRAME_SIZE) {
            continue;                              /* wrong length: ignore */
        }
        if (frame[0] != FRAME_START) {
            continue;                              /* wrong start: ignore */
        }
        checksum = frame[1] ^ frame[2] ^ frame[3] ^ frame[4];
        if (frame[5] != checksum) {
            continue;                              /* wrong checksum: ignore */
        }

        /* The frame is correct: show the counter */
        XGpio_DiscreteWrite(&gpio, 2, frame[2] * 256 + frame[1]);   /* LEDs    */
        XGpio_DiscreteWrite(&gpio, 1, frame[3] * 256 + frame[4]);   /* display */
    }

    return 0;
}
