#!/bin/sh
# gp-pi-sense-hat build script
# (c) 2021, Greg PFISTER. MIT License

[ -d ./build ] && echo 'Build folder exists' || mkdir ./build
[ -d ./build/hats ] && echo 'Found Rapsberry Pi Hats tools' || (cd ./build && git clone https://github.com/raspberrypi/hats.git && cd hats/eepromutils && make )

dtc -O dtb -o ./build/gp-pi-sense-hat.dtbo ./dts/gp-pi-sense-hat.dts
./build/hats/eepromutils/eepmake ./eeprom/gp-pi-sense-hat_eeprom.txt ./build/gp-pi-sense-hat.eep ./build/gp-pi-sense-hat.dtbo
