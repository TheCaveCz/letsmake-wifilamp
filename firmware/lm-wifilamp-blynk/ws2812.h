// This is a slightly modified version of the Michael Miller's
// ESP8266 work for the NeoPixelBus library: github.com/Makuna/NeoPixelBus
// Needs to be a separate .c file to enforce ICACHE_RAM_ATTR execution.

#ifndef ESP8266
#error This code is for Esp8266 only
#endif

#ifndef __WS2812_H
#define __WS2812_H

#include <Arduino.h>


void ws2812Setup();
void ws2812Send(const uint8_t *pixels, uint32_t bytesCount);


#endif // __WS2812_H

