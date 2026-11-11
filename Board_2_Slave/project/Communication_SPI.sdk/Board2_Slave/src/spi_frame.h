/*
 * spi_frame.h
 * Format of the SPI frame sent by the master to the slave.
 * The same file is used by both boards.
 *
 * A frame has 6 bytes:
 *   byte 0 : 0xA5            (start of frame)
 *   byte 1 : LEDs 0 to 7
 *   byte 2 : LEDs 8 to 15
 *   byte 3 : left 2 digits of the display
 *   byte 4 : right 2 digits of the display
 *   byte 5 : checksum = byte1 XOR byte2 XOR byte3 XOR byte4
 */
#ifndef SPI_FRAME_H
#define SPI_FRAME_H

#define FRAME_START  0xA5
#define FRAME_SIZE   6

#endif
