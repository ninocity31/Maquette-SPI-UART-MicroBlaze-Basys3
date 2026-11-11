/******************************************************************************
 * spi_frame.h -- SPI protocol shared by the master and the slave board.
 * This file must be IDENTICAL in both projects.
 *
 * One frame = 6 bytes sent while CS is held low, SPI mode 0, MSB first:
 *
 *   byte 0 : SYNC   = 0xA5 (constant)
 *   byte 1 : LED_LO = LEDs 7..0
 *   byte 2 : LED_HI = LEDs 15..8
 *   byte 3 : SEG_L  = left display  (digits 3-2) -> HEX(15:8)
 *   byte 4 : SEG_R  = right display (digits 1-0) -> HEX(7:0)
 *   byte 5 : CHK    = LED_LO ^ LED_HI ^ SEG_L ^ SEG_R
 *
 * Example: LEDs 0, 7, 10..13 on, "12" left, "AB" right -> A5 81 3C 12 AB 04
 *
 * The slave applies a frame only when CS goes back high, and only if it is
 * exactly 6 bytes long, starts with 0xA5 and has a valid CHK.
 * During the next frame, the slave returns on MISO the status of the
 * previous one (first byte, STATUS_xxx below).
 ******************************************************************************/
#ifndef SPI_FRAME_H
#define SPI_FRAME_H

#include "xil_types.h"

#define FRAME_SYNC       0xA5
#define FRAME_LENGTH     6

#define IDX_SYNC         0
#define IDX_LED_LO       1
#define IDX_LED_HI       2
#define IDX_SEG_L        3
#define IDX_SEG_R        4
#define IDX_CHK          5

#define STATUS_OK        0x00
#define STATUS_ERR_LEN   0xE1   /* not 6 bytes            */
#define STATUS_ERR_SYNC  0xE2   /* first byte is not 0xA5 */
#define STATUS_ERR_CHK   0xE3   /* wrong checksum         */

/* Checksum: XOR of the 4 data bytes (SYNC excluded) */
static inline u8 frame_chk(const u8 *f)
{
    return (u8)(f[IDX_LED_LO] ^ f[IDX_LED_HI] ^ f[IDX_SEG_L] ^ f[IDX_SEG_R]);
}

/* Fill f[0..5] from the requested state */
static inline void frame_build(u8 *f, u16 leds, u8 seg_l, u8 seg_r)
{
    f[IDX_SYNC]   = FRAME_SYNC;
    f[IDX_LED_LO] = (u8)(leds & 0xFF);
    f[IDX_LED_HI] = (u8)(leds >> 8);
    f[IDX_SEG_L]  = seg_l;
    f[IDX_SEG_R]  = seg_r;
    f[IDX_CHK]    = frame_chk(f);
}

#endif /* SPI_FRAME_H */
