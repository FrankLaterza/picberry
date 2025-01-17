# picberry
PIC Programmer using GPIO connector

Copyright 2017 Francesco Valla

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

## Overview

_picberry_ is a PIC programmer using GPIOs that doesn't require additional programming hardware.

It theorically supports dsPIC33E/PIC24E, dsPIC33F/PIC24H, PIC24FJ, PIC18FxxJxx, PIC32MX, PIC32MZ and PIC32MK families, but only some PICs have been tested.

### Supported hosts

 Currently _picberry_ has support for the following host boards/processors:

- the [Raspberry Pi](https://www.raspberrypi.org/)
- Allwinner A10-based boards (like the [Cubieboard](http://cubieboard.org/))
- TI AM335x-based boards (like the [Beaglebone Black](https://beagleboard.org/black) or the [AM3359 ICEv2](http://www.ti.com/tool/tmdsice3359)).

Support for additional boards and processors can be easily added, providing the following macro in a header file inside the _hosts_ folder:

	/* GPIO registers address */
	#define GPIO_BASE		// base address for the GPIO controller
	#define BLOCK_SIZE		// size of the GPIO bank
	#define PORTOFFSET		// port offset for letter-defined gpios

	/* GPIO setup macros */
	#define GPIO_IN(g)		// set gpio g as input
	#define GPIO_OUT(g)		// set gpio g as output
	#define GPIO_SET(g)		// set gpio g as high
	#define GPIO_CLR(g)		// set gpio g as low
	#define GPIO_LEV(g)		// read level of gpio g

	/* default GPIO <-> PIC connections */
	#define DEFAULT_PIC_CLK		// default gpio for PGC line
	#define DEFAULT_PIC_DATA	// default gpio for PGD line
	#define DEFAULT_PIC_MCLR	// default gpio for MCLR line

A build rule inside the Makefile for the specific platform has to be added too.

## Building and Installing picberry

picberry is written using C++11 features, so it requires at least g++ version 4.7.

To build picberry launch `make TARGET`, where _TARGET_ can be one of the following:

|   _TARGET_    | Processor/Board                            |
| ------------- | ------------------------------------------ |
| raspberrypi   | Raspberry Pi all models                    |
| am335x        | Boards based on TI AM335x (BeagleBone)     |
| a10           | Boards based on Allwinner A10 (Cubieboard) |

Then launch `sudo make install` to install it to /usr/bin.

To change destination prefix use PREFIX=, e.g. `sudo make install PREFIX=/usr/local`.

For cross-compilation, given that you have the required cross toolchain in you PATH, simply export the `CROSS_COMPILE` variable before launching `make`, e.g. `CROSS_COMPILE=arm-linux-gnueabihf- make raspberrypi`.

## Using picberry

	picberry [options]

Programming Options

	--help,             -h                print help
	--server=port,      -S port           server mode, listening on given port
	--log=[file],       -l [file]         redirect the output to log file(s)
	--gpio=PGC,PGD,MCLR -g PGC,PGD,MCLR   GPIO selection in form [PORT:]NUM (optional)
	--family=[family],  -f [family]       PIC family [default: dspic33f]
	--read=[file.hex],  -r [file.hex]     read chip to file [defaults to ofile.hex]
	--write=file.hex,   -w file.hex       bulk erase and write chip
	--erase,            -e                bulk erase chip
	--blankcheck,       -b                blank check of the chip
	--regdump,          -d                read configuration registers
	--noverify                            skip memory verification after writing
	--debug                               turn ON debug
	--fulldump                            don't detect empty sections, make complete dump (PIC32)
	--program-only                        read/write only program section (PIC32)
	--boot-only                           read/write only boot section (PIC32)

Runtime Options

	-reset, -R                           reset

For Example, to connect the PIC to RPi GPIOs 11 (PGC), 9 (PGD), 22 (MCLR) and write on a dsPIC33FJ128GP802 the file fw.hex:

	picberry -w fw.hex -g 11,9,22 -f dspic33f

To connect the PIC to A10 GPIOs B15 (PGC), B17 (PGD), I15 (MCLR):

	picberry -w fw.hex -g B:15,B:17,I:15 -f dspic33f

### Programming Hardware

To use picberry you will need only the "recommended minimum connections" outlined in each PIC datasheet.

Between PIC and the SoC you must have the four basic ICSP lines: PGC (clock), PGD (data), MCLR (Reset), GND.
You can also connect PIC VDD line to target board 3v3 line, but be careful: such pins normally have low current capabilities, so consider your circuit current drawn!

If not specified in the command line, the default GPIOs <-> PIC connections are the following:

for the Raspberry Pi:

	PGC  <-> GPIO23
	PGD  <-> GPIO24
	MCLR <-> GPIO18

for the Allwinner A10:

	PGC  <-> PB15
	PGD  <-> PB17
	MCLR <-> PB12

for BeagleBone Black (AM335x):

	PGC  <-> GPIO60 (P9.12)
	PGD  <-> GPIO49 (P9.23)
	MCLR <-> GPIO48 (P9.15)


### Remote GUI

Remote GUI is written in Qt5 and allows to control a picberry session running in *server mode* (that is, launched with the  `-S <port>` command line argument).

To compile it, just launch `qmake` and then `make` in the *remote_gui* folder.

## References

- [dsPIC33E/PIC24E Flash Programming Specification](http://ww1.microchip.com/downloads/en/DeviceDoc/70619B.pdf)
- [dsPIC33F/PIC24H Flash Programming Specification](http://ww1.microchip.com/downloads/en/DeviceDoc/70152H.pdf)
- [PIC24FJ Flash Programming Specification](http://ww1.microchip.com/downloads/en/DeviceDoc/30010057d.pdf)
- [PIC24FJXXGA0XX Flash Programming Specification](http://ww1.microchip.com/downloads/en/DeviceDoc/39768d.pdf)
- [PIC24FJXXXDA1/DA2/GB2/GA3/GC0 Families Flash Programming Specification](http://ww1.microchip.com/downloads/en/DeviceDoc/39970e.pdf)
- [PIC24FJXXXGA2/GB2 Families Flash Programming Specification](http://ww1.microchip.com/downloads/en/DeviceDoc/30000510f.pdf)
- [PIC10(L)F320/322 Flash Programming Specification](http://ww1.microchip.com/downloads/en/DeviceDoc/41572D.pdf)
- [PIC12(L)F1822/PIC16(L)F182X Flash Programming Specification](http://ww1.microchip.com/downloads/en/DeviceDoc/41390D.pdf)
- [PIC18F2XJXX/4XJXX Family Programming Specification](http://ww1.microchip.com/downloads/en/DeviceDoc/39687e.pdf)
- [PIC32 Flash Programming Specification](http://ww1.microchip.com/downloads/en/DeviceDoc/60001145S.pdf)

## Licensing

picberry is released under the GPLv3 license; for full license see the `LICENSE` file.

The Microchip name and logo, PIC, In-Circuit Serial Programming, ICSP are registered trademarks of Microchip Technology Incorporated in the U.S.A. and other countries.

Raspberry Pi is a trademark of The Raspberry Pi Foundation.
