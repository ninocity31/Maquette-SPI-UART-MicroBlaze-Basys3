# SPI communication between two FPGA boards (MicroBlaze, Basys 3)

## Briefing

We want to simulate SPI communication between an FPGA and an SPI interface.
We use two FPGA boards: one board controls the other over SPI.

- **Board 1 (master)** sends a counter over SPI every 100 ms. It also sends measurements to a PC over UART.
- **Board 2 (slave)** receives the counter and shows it on its LEDs and its display.

Both boards use the same FPGA design: a MicroBlaze processor with an SPI block, a UART block and a GPIO block.
Only the C program is different.

![Overview](docs/figures/overview.png)

## Folders

| Folder | Content |
|---|---|
| `Board_1_Master/project/` | Full Vivado 2019.1 and SDK 2019.1 project of board 1 |
| `Board_2_Slave/project/` | Full Vivado 2019.1 and SDK 2019.1 project of board 2 |
| `Board_X/vivado/` | Block design script and design sources |
| `Board_X/bitstream/` | Ready-to-use bitstream and hardware export |
| `Board_X/sdk_src/` | C code: `master.c` or `slave.c`, and `spi_frame.h` |

## Hardware

![Block design](docs/figures/block_design.png)

### Blocks and connections

| Block | Role | Connected to |
|---|---|---|
| Clocking Wizard | 100 MHz clock | `sys_clock` in, all blocks out |
| Processor System Reset | Reset | BTNC button in, all blocks out |
| MicroBlaze + 64 KB memory + MDM | Runs the C program | AXI bus (made with *Run Block Automation*) |
| AXI Interconnect | Bus between the processor and the blocks | UART Lite, Quad SPI, GPIO |
| AXI UART Lite | Link to the PC | `usb_uart` (Board tab) |
| AXI Quad SPI | SPI link between the boards | `SPI_0` → *Make External* → Pmod JA |
| AXI GPIO (2 channels) | LEDs and display | Channel 1 → `afficheur.vhd`, channel 2 → `led_16bits` |
| `afficheur.vhd` | Drives the 4-digit display | `HEX` ← GPIO channel 1; `SEPT_SEG`, `AN` → *Make External* |

### Block settings

| Block | Setting | Value |
|---|---|---|
| AXI Quad SPI | Board tab | `SPI_0` = Custom |
| | Mode / width | Standard / 8 bits |
| | Frequency Ratio | 16 × 5 = 80 (SCK = 1.25 MHz) |
| | No. of Slaves | 1 |
| | Enable Master Mode | unchecked (the C code selects master or slave) |
| | Enable STARTUP Primitive | unchecked |
| AXI GPIO | Channels | 2 channels, 16-bit outputs |
| AXI UART Lite | Baud rate | 9600 |
| MicroBlaze | Local memory | 64 KB |

![AXI Quad SPI settings](docs/figures/axi_quad_spi_config.png)

## Wiring

| Signal | Board 1 | Board 2 |
|---|---|---|
| SCK | JA1 | JA1 |
| CS | JA2 | **JA7** |
| MOSI | JA3 | JA3 |
| MISO | JA4 | JA4 |
| GND | JA5 | JA5 |

![Wiring](docs/figures/wiring.png)

- The CS wire goes from JA2 (board 1) to JA7 (board 2).
- GND must be connected.
- Never connect the 3.3 V pins (JA6, JA12).

## SPI frame

One frame is 6 bytes, sent while CS is low.

| Byte | Name | Content |
|---|---|---|
| 0 | SYNC | `0xA5` (always the same) |
| 1 | LED_LO | LEDs 0 to 7 |
| 2 | LED_HI | LEDs 8 to 15 |
| 3 | SEG_L | left 2 digits of the display |
| 4 | SEG_R | right 2 digits of the display |
| 5 | CHK | XOR of bytes 1 to 4 |

![SPI frame](docs/figures/spi_frame.png)

Board 2 uses a frame only when CS goes back high, and only if the frame is valid (6 bytes, `0xA5`, correct CHK).

## Code

- **`master.c` (board 1):** shows `1111` and all LEDs for 1 s at start-up, then keeps `1111`. Every 100 ms, it adds 1 to the counter, sends it in an SPI frame, and sends a `$RSSI` line to the PC.
- **`slave.c` (board 2):** shows `2222` and every other LED at start-up. Then it waits for frames and shows the counter: in binary on the LEDs, in decimal on the display.
- **`spi_frame.h`:** the frame format, shared by both programs.

From the PC terminal of board 1, you can type `p` (pause), `r` (run), `+` (faster) or `-` (slower).

## How to use

1. Connect the boards with both boards switched off, then plug in both USB cables.
2. Open SDK 2019.1 with `Board_X/project/Communication_SPI.sdk` as workspace. Use *File → Import → Existing Projects into Workspace* on that folder, then *Build All*.
3. For each board: *Xilinx → Program FPGA*, select the board's cable, and replace `bootloop` with the program's `.elf` file. Program board 2 first, then board 1.
4. Open a serial terminal at 9600 baud on each board.

**Result:** board 1 shows `1111`. Board 2 counts on its LEDs and its display. The PC receives `$RSSI` lines.
