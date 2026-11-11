/*
 * master.c  -  Board 1 (master)
 *
 * What this program does:
 *   1. Shows "1111" on the display (to recognise board 1).
 *   2. Every 100 ms:
 *        - adds 1 to a counter,
 *        - sends the counter to board 2 in an SPI frame of 6 bytes,
 *        - sends the number of frames sent to the PC (UART, 9600 baud).
 */

#include "xparameters.h"
#include "xspi.h"
#include "xgpio.h"
#include "xil_printf.h"
#include "sleep.h"
#include "spi_frame.h"

XSpi  spi;      /* the SPI block  */
XGpio gpio;     /* the GPIO block (channel 1 = display, channel 2 = LEDs) */

int main(void)
{
    u8  frame[FRAME_SIZE];   /* bytes to send */
    u8  answer[FRAME_SIZE];  /* bytes received at the same time (not used) */
    u16 counter = 0;         /* value sent to board 2 */
    int frames_sent = 0;     /* number of frames sent */
    int thousands, hundreds, tens, units;

    xil_printf("Board 1 (master) started\r\n");

    /* ---------- 1. GPIO: LEDs and display ---------- */
    XGpio_Initialize(&gpio, XPAR_GPIO_0_DEVICE_ID);
    XGpio_SetDataDirection(&gpio, 1, 0x0000);   /* channel 1 = outputs */
    XGpio_SetDataDirection(&gpio, 2, 0x0000);   /* channel 2 = outputs */

    /* Signature of board 1: "1111" and all LEDs on for 1 second */
    XGpio_DiscreteWrite(&gpio, 1, 0x1111);
    XGpio_DiscreteWrite(&gpio, 2, 0xFFFF);
    sleep(1);
    XGpio_DiscreteWrite(&gpio, 2, 0x0000);      /* LEDs off, "1111" stays */

    /* ---------- 2. SPI in master mode ---------- */
    XSpi_Initialize(&spi, XPAR_SPI_0_DEVICE_ID);
    /* MASTER = this board drives the clock.
       MANUAL_SSELECT = CS stays low during the 6 bytes. */
    XSpi_SetOptions(&spi, XSP_MASTER_OPTION | XSP_MANUAL_SSELECT_OPTION);
    XSpi_SetSlaveSelect(&spi, 0x01);            /* we have one slave: number 0 */
    XSpi_Start(&spi);
    XSpi_IntrGlobalDisable(&spi);               /* no interrupts */

    /* ---------- 3. Main loop ---------- */
    while (1) {
        counter = counter + 1;

        /* Split the counter into 4 decimal digits (example: 1234) */
        thousands = (counter / 1000) % 10;
        hundreds  = (counter / 100) % 10;
        tens      = (counter / 10) % 10;
        units     = counter % 10;

        /* Build the frame */
        frame[0] = FRAME_START;
        frame[1] = counter & 0xFF;                /* LEDs 0 to 7  */
        frame[2] = (counter >> 8) & 0xFF;         /* LEDs 8 to 15 */
        frame[3] = thousands * 16 + hundreds;     /* left digits  */
        frame[4] = tens * 16 + units;             /* right digits */
        frame[5] = frame[1] ^ frame[2] ^ frame[3] ^ frame[4];   /* checksum */

        /* Send the 6 bytes (CS goes low, 6 bytes, CS goes high) */
        XSpi_Transfer(&spi, frame, answer, FRAME_SIZE);
        frames_sent = frames_sent + 1;

        /* Tell the PC how many frames were sent */
        xil_printf("Frames sent: %d\r\n", frames_sent);

        usleep(100000);                           /* wait 100 ms */
    }

    return 0;
}
