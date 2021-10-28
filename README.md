[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

# gp-pi-sense-hat

Alternative EEPROM firmware for the RPi Sense Hat to be used in the [gp-pi-sense project](https://pi-sense.gpfister.org).

## About

The default behaviour of the rpi-sense device tree overlay loaded on the eeprom is to take control of all sensors (pressure, humidity and temperature, IMU), the Joystick and the Led Matrix.

However, I wanted with the [gp-pi-sense project](https://pi-sense.gpfister.org) to go a bit more directly to the hardware, and bypass the [AstroPi sense-hat Python library](https://github.com/astro-pi/python-sense-hat), so I decided to build another firmware that only allow for the default behaviour of the led matrix (exposed as a frame buffer), while all the rest is not handled by the kernel.

## Very important !!!

This tutorial assumes that you are fairly acquainted with the configuration of a Raspberry Pi boot logic.

Though it is not possible to break the hardware, you need to make sure you are comfortable going backward if you want to use the RPi Sense Hat is it was intended.

## Requirements (for building)

### Hardware

It has been tested using:

- A Raspberry Pi 4 4GB
- A Genuine Rapsberry Pi Sense Hat

### Software

It has been tested on Ubuntu Server 20.04 64 bit for Raspberry.

`build-essential` and `git` are required to build both the eeprom tools and the device-tree overlay binary.

```
apt install build-essential git
```

At last, the `i2c-tools` are required.

```
apt install i2c-tools
```

## Build instruction

To build, clone the repository, then run `./build.sh` script:

```
git clone https://github.com/gpfister/gp-pi-sense-hat.git
cd gp-pi-sense-hat.git
./build.sh
```

Before building, it will download [Raspberry PI Hat repository](https://github.com/raspberrypi/hats) and build the eeprom tools that come with.

At the end, you should find:

- ./build/gp-pi-sense-hat.eep
- ./build/gp-pi-sense-hat.dtbo (which can be ignore)

If that's the case, you can move on the next step

## Flashing the EEPROM

!!! Before flashing, make sure you are comfortable going back to the defaults !!! Instructions can be found [here](https://www.raspberrypi.com/documentation/accessories/sense-hat.html#sense-hat-hardware).

To flash the EEPROM, the I2C bus 0 must be unabled. If that's not the case, then add `dtparams=dtparam=i2c_vc=on` in `/boot/firmware/syscfg.txt`, and `reboot`.

To make sure the EEPROM can be flashed, check if it is detected at address 0x50:

```
sudo i2cdetect -y 0
```

You should get:

```
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
50: 50 -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --
```

Then, unlock the EEPROM for writing:

```
i2cset 1 0x46 0xf3 1'
```

Now, flash the EEPROM:

```
cd ./build
sudo ./hats/eepromutils/eepflash.sh -f=gp-pi-sense-hat.eep -t=24c32 -w
```

When done, lock the EEPROM for update:

```
i2cset 1 0x46 0xf3 0'
```

And `reboot`.

## Resources

Here are some links to the document I used for this, and also in case you want to go back to factory settings.

- [AstroPi Project](https://astro-pi.org)
- [RPi Sense Hat documentation](https://www.raspberrypi.com/documentation/accessories/sense-hat.html#sense-hat-hardware)
- [RPi Hats instructions and software package](https://github.com/raspberrypi/hats)
- [RPi Kernel device-tree overlays](https://github.com/raspberrypi/linux/tree/rpi-5.10.y/arch/arm/boot/dts)

## Contributions

See instructions [here](./CONTRIBUTIONS.md).

## License

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

See license [here](./LICENSE).
