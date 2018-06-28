# Let's make: WiFi Lamp

ESP8266 chip on Wemos D1 mini module that is driving WS2812 LED strip, one tactile switch or touch sensor for manual control.
Firmware contains React web app for controlling the lamp via HTTP REST API.

More resources:
* [3D prints](stl)
* Firmware
  * [Original](firmware/lm-wifilamp) - uses [Arduino core for ESP8266](https://github.com/esp8266/Arduino), using [Blynk](https://blynk.cc) platform
  * [Tester](firmware/lm-wifilamp-test) - testing sketch
* [Photos](pictures)
* [PCB](board) - simple PCB to avoid messing with lots of wires. Created in EAGLE 7.7

## Setup

* Install the Blynk app and Arduino library ([https://www.blynk.cc/getting-started/](https://www.blynk.cc/getting-started/))
* Create new auth token
* Compile and upload the firmware
* Connect to the wifilamp AP
* Navigate to `http://192.168.4.1`
* Enter WiFi credentials and auth token

## Blynk project

![Blynk project](pictures/blynk-app.png)

Scan this QR code from Blynk app to clone the project.

![Blynk QR code](pictures/blynk-qr.png)

## How it looks

![The Device](pictures/final.jpg)
