#!/bin/bash

if [ $# -eq 0 ]; then
    echo "please provide a file from the hex folder without the extension."
    exit 1
fi

hex=$1

# reset pins
raspi-gpio set 18 op dl && raspi-gpio set 23 op dl && raspi-gpio set 24 op dl

# erase device
./picberry -e

# reset pins
raspi-gpio set 18 op dl && raspi-gpio set 23 op dl && raspi-gpio set 24 op dl

# upload pins
./picberry -w ../hex/$hex.hex

# reset pins
raspi-gpio set 18 op dl && raspi-gpio set 23 op dl && raspi-gpio set 24 op dl

# reset device
./picberry -R