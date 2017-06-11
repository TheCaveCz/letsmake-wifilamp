Task pixelTask(20, TASK_FOREVER, &pixelTaskCb, &scheduler);

uint8_t pixelsR;
uint8_t pixelsG;
uint8_t pixelsB;

uint8_t pixelsBuffer[PIXELS_BYTE_COUNT];

#ifdef ESP8266
// ESP8266 show() is external to enforce ICACHE_RAM_ATTR execution
extern "C" void ICACHE_RAM_ATTR espShow(uint8_t pin, uint8_t *pixels, uint32_t numBytes);

#define pixelsFlush() espShow(PIXELS_PIN, pixelsBuffer, PIXELS_BYTE_COUNT)

#endif


void pixelsSetup() {
  pinMode(PIXELS_PIN, OUTPUT);
  digitalWrite(PIXELS_PIN, LOW);

  pixelsSet(255, 255, 255);
  pixelsSet(0, 0, 0);
}

void pixelTaskCb() {
  uint8_t v;
  //    cnt++;
  //    if (cnt < 50) {
  //      v = map(cnt, 0, 49, 0, 255);
  //    } else if (cnt < 100) {
  //      v = map(cnt, 50, 99, 255, 0);
  //    } else {
  //      v = 0;
  //      cnt = 0;
  //    }
  //

  v = digitalRead(D5) ? 255 : 0;
  pixelsSet(v, v, v);
}

void pixelsSet(uint8_t r, uint8_t g, uint8_t b) {
  if (pixelsR == r && pixelsG == g && pixelsB == b) return;

  pixelsR = r;
  pixelsG = g;
  pixelsB = b;

  for (int i = 0; i < PIXELS_BYTE_COUNT; i += 3) {
    pixelsBuffer[i] = g;
    pixelsBuffer[i + 1] = r;
    pixelsBuffer[i + 2] = b;
  }

  pixelsFlush();
}

