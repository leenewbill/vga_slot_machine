# SM2: VGA Slot Machine

An FPGA-based slot machine featuring animated fruit reels and VGA graphics, developed for the Digilent Nexys A7-100T development board.

**Repository:** [github.com/leenewbill/vga_slot_machine](https://github.com/leenewbill/vga_slot_machine)

SM2 builds on the original Lattice iCE40 slot machine project (SM1), adding a video display, animated reels, and a more sophisticated hardware architecture. The project was developed as an engineering portfolio and interview demonstration.

## Project Overview

The project began in March 2024 following a demonstration of SM1. The goal was to create a more visually engaging slot machine that could be demonstrated remotely during engineering interviews.

The original idea involved adding an HDMI display, but the Nexys A7's existing VGA output provided a simpler path. The video system was developed using ideas and resources from [Project F](https://projectf.io/), an open-source FPGA graphics project by Will Green.

## Features

- Three independently animated fruit reels.
- Eight symbol types: blank, lime, orange, grape, banana, blueberry, cherry, and coconut.
- Sequential reel stopping, with each reel stopping at a different time.
- VGA graphics rendered using hardware sprites and bitmap images.
- 640×480 video resolution at approximately 60 Hz.
- Credit balance and payout calculations.
- Four-digit seven-segment display, switchable between credit balance and reel symbols.
- Debounced push-button and lever inputs.
- LED counter tracking lever activations.

## Hardware

| Component | Description |
|---|---|
| FPGA board | Digilent Nexys A7-100T |
| FPGA | Xilinx Artix-7 |
| System clock | 100 MHz |
| Pixel clock | 25.2 MHz |
| Video output | VGA, 640×480 at 60 Hz |
| Color output | 12-bit RGB (4 bits per channel) |

### Controls and Display

The top-level design uses the following board inputs:

- `RST`: Active-high reset.
- `BUTT1`: Switches the seven-segment display between the credit balance and reel symbols.
- `LEVER`: Initiates a slot machine play.

The seven-segment display shows the credit balance by default. Pressing `BUTT1` switches to a display of the three reel symbols. The LEDs count debounced lever activations.

## Architecture

The design uses a combination of Verilog and SystemVerilog modules.

### Game Logic

- **`sm_engine`**: Main slot machine controller. Manages game state, credit balance, reel animation, and payout updates.
- **`reels_engine`**: Controls reel animation and sequential stopping of the three reels.
- **`virtual_reel`**: Maps virtual reel positions to physical reel positions. The virtual positions are driven by a free-running counter.
- **`physical_reel`**: Maps physical reel positions to fruit symbols.
- **`payout_table`**: Determines the payout for a completed symbol combination.

### Video System

- **`vga`**: Coordinates VGA output, pixel clock generation, and reel graphics.
- **`clock_480p`**: Generates the 25.2 MHz pixel clock from the 100 MHz system clock.
- **`display_480p`**: Generates 640×480 video timing.
- **`reels_sprites`**: Controls the three reel sprites and their bitmap images.
- **`sprite`**: Hardware sprite implementation with scaling.
- **`rom_async`**: Asynchronous ROM used for sprite bitmap data.
- **`bram_sdp`**: Simple dual-port block RAM.
- **`clut_simple`**: Color lookup table.

### Input and Display Support

- **`debouncer`**: Synchronizes and debounces mechanical inputs.
- **`binary_to_bcd`**: Converts binary values to BCD.
- **`seven_seg_disp`**: Drives the seven-segment display.

### Clock-Domain Crossing

The game logic operates on the 100 MHz system clock, while the VGA graphics system operates on the 25.2 MHz pixel clock.

The design transfers reel symbol and position updates between these clock domains using a toggle-based synchronization scheme. A four-stage synchronizer detects updates in the pixel clock domain, where the associated data is captured.

The XDC constraints include a `set_max_delay -datapath_only` constraint to limit data-path skew between the two clock domains.

## Repository Structure

```text
.
├── bitmap/       # Fruit symbol and color palette bitmap data
├── constraint/   # Nexys A7-100T XDC constraints
├── source/       # Verilog and SystemVerilog source files
└── testbench/    # Simulation testbench
```

## Development History

### March–May 2024: Project Initiation

The project began with the goal of adapting the original slot machine for a more engaging interview demonstration. After considering HDMI output, development shifted to the Nexys A7's built-in VGA interface.

Project F provided useful examples and techniques for FPGA-based video generation.

### May–June 2024: VGA Graphics

The initial video implementation integrated Project F examples into the slot machine design.

Development included:

- Generating VGA timing and displaying bitmap images.
- Implementing hardware sprites for the fruit symbols.
- Positioning and multiplexing sprites for the three reels.
- Synchronizing game data with the pixel clock domain.
- Refactoring the reel and game logic to support video output.

By June 2024, the fruit symbols were displayed on screen and the project was sufficiently functional for an interview demonstration.

### December 2024: Animated Reels

Development resumed in December to improve reel behavior and resolve payout issues.

The reels were refactored to support animation, with previous symbols sliding downward and new symbols entering from above. Each reel spins at a different speed and stops sequentially.

The balance display was also updated to account for the cost of each play.

### January 2025: Clock-Domain Crossing and Hardware Validation

The video and game logic interfaces were further refined to address clock-domain crossing issues between the 100 MHz system clock and 25.2 MHz pixel clock.

A toggle-based synchronization approach and corresponding timing constraints were implemented.

On January 30, 2025, the project was rebuilt from a fresh repository clone, a new Vivado project was created, and a bitstream was generated and successfully tested on the Nexys A7.

## Current Development

The original hardware demonstration was completed and verified in January 2025.

Current work focuses on documenting the design, reviewing the RTL, and developing a more complete simulation and verification environment. The original testbench is outdated and is being replaced as part of the current verification effort.

The goal is to preserve the original hardware functionality while improving the project's maintainability and demonstrating contemporary FPGA design and verification practices.

## References and Acknowledgments

- [Digilent Nexys A7](https://digilent.com/reference/programmable-logic/nexys-a7/start)
- [Project F](https://projectf.io/) by Will Green: Open-source FPGA graphics and video design resources.
- Thomas Kappenman / Digilent: Original seven-segment display driver adapted for this project.

Project F source files retain their original MIT-license attribution. Other incorporated source files retain their original copyright and license notices.