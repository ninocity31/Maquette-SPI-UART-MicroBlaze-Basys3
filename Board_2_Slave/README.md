# Board 2 — Slave

- `project/`: full Vivado 2019.1 project and SDK 2019.1 workspace (application `Board2_Slave`, `slave.c`)
- `vivado/`: block design script and sources (same as board 1)
- `bitstream/`: exported hardware and bitstream (same as board 1)
- `sdk_src/`: `slave.c`, `spi_frame.h`

Receives the SPI frames of board 1, checks them and shows the counter on the LEDs and the 7-segment display. The master's CS arrives on JA7 (`spisel`). See the [main README](../README.md).
