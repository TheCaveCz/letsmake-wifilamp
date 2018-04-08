// This is a slightly modified version of the Michael Miller's
// ESP8266 work for the NeoPixelBus library: github.com/Makuna/NeoPixelBus
// Needs to be a separate .c file to enforce ICACHE_RAM_ATTR execution.

#include "ws2812.h"

extern "C" {
#include <eagle_soc.h>
#include <ets_sys.h>
#include <uart.h>
#include <uart_register.h>
}

#define UART1 1
#define UART1_INV_MASK (0x3f << 19)

// Gets the number of bytes waiting in the TX FIFO of UART1
static inline uint8_t getUartTxFifoLength() {
  return (U1S >> USTXC) & 0xff;
}

// Append a byte to the TX FIFO of UART1
// You must ensure the TX FIFO isn't full
static inline void enqueue(uint8_t byte) {
  U1F = byte;
}

#define UART_BAUDRATE 3200000 // 800mhz, 4 serial bytes per NeoByte

void ws2812Setup() {
  // Configure the serial line with 1 start bit (0), 6 data bits and 1 stop bit (1)
  Serial1.begin(UART_BAUDRATE, SERIAL_6N1, SERIAL_TX_ONLY);

  // Invert the TX voltage associated with logic level so:
  //    - A logic level 0 will generate a Vcc signal
  //    - A logic level 1 will generate a Gnd signal
  CLEAR_PERI_REG_MASK(UART_CONF0(UART1), UART1_INV_MASK);
  SET_PERI_REG_MASK(UART_CONF0(UART1), (BIT(22)));
}

const uint8_t* ICACHE_RAM_ATTR uartFill(const uint8_t* pixels, const uint8_t* end) {
  // Remember: UARTs send less significant bit (LSB) first so
  //      pushing ABCDEF byte will generate a 0FEDCBA1 signal,
  //      including a LOW(0) start & a HIGH(1) stop bits.
  // Also, we have configured UART to invert logic levels, so:
  const uint8_t _uartData[4] = {
    0b110111, // On wire: 1 000 100 0 [Neopixel reads 00]
    0b000111, // On wire: 1 000 111 0 [Neopixel reads 01]
    0b110100, // On wire: 1 110 100 0 [Neopixel reads 10]
    0b000100, // On wire: 1 110 111 0 [NeoPixel reads 11]
  };
  uint8_t avail = (UART_TX_FIFO_SIZE - getUartTxFifoLength()) / 4;
  if (end - pixels > avail)  {
    end = pixels + avail;
  }
  while (pixels < end)  {
    uint8_t subpix = *pixels++;
    enqueue(_uartData[(subpix >> 6) & 0x3]);
    enqueue(_uartData[(subpix >> 4) & 0x3]);
    enqueue(_uartData[(subpix >> 2) & 0x3]);
    enqueue(_uartData[ subpix       & 0x3]);
  }
  return pixels;
}

void ws2812Send(const uint8_t *pixels, uint32_t bytesCount) {
  const uint8_t* ptr = pixels;
  const uint8_t* end = ptr + bytesCount;
  while (ptr != end) {
    ptr = uartFill(ptr, end);
  }
}

