# Board 1 — Master

- `project/`: full Vivado 2019.1 project and SDK 2019.1 workspace (application `Communication_SPI_BASYS3`, `master.c`)
- `vivado/`: block design script and sources (same as board 2)
- `bitstream/`: exported hardware and bitstream (same as board 2)
- `sdk_src/`: `master.c`, `spi_frame.h`

Sends a counter to board 2 over SPI every 100 ms and simulated RSSI lines to the PC over UART. See the [main README](../README.md).
