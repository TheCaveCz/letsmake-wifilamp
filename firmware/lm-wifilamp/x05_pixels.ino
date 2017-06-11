
uint16_t pixelsCurrentG;
uint16_t pixelsCurrentR;
uint16_t pixelsCurrentB;

uint8_t pixelsTargetG;
uint8_t pixelsTargetR;
uint8_t pixelsTargetB;

int16_t pixelsDeltaG;
int16_t pixelsDeltaR;
int16_t pixelsDeltaB;

uint16_t pixelsDeltaSteps;

uint8_t pixelsBuffer[PIXELS_BYTE_COUNT];

uint32_t pixelsTaskTime;

#ifdef ESP8266
// ESP8266 show() is external to enforce ICACHE_RAM_ATTR execution
extern "C" void ICACHE_RAM_ATTR espShow(uint8_t pin, uint8_t *pixels, uint32_t numBytes);

#endif


#define bail(msg) logInfo(msg);pixelsSet(255,128,0);while (1) { delay(1); }


void pixelsSetup() {
  pinMode(PIXELS_PIN, OUTPUT);
  digitalWrite(PIXELS_PIN, LOW);

  pixelsSet(0, 0, 0);
  pixelsTaskTime = 0;
}

void pixelsTask() {
  uint32_t now = millis();
  if (now - pixelsTaskTime < PIXELS_TASK_INTERVAL) return;
  pixelsTaskTime = now;

  if (pixelsDeltaSteps) {
    pixelsDeltaSteps--;
    if (pixelsDeltaSteps) {
      // still some steps left, add delta
      pixelsCurrentG += pixelsDeltaG;
      pixelsCurrentR += pixelsDeltaR;
      pixelsCurrentB += pixelsDeltaB;
    } else {
      // steps got to zero, update with target color
      pixelsCurrentG = pixelsTargetG << 8;
      pixelsCurrentR = pixelsTargetR << 8;
      pixelsCurrentB = pixelsTargetB << 8;
    }
    pixelsUpdate();
  }
}

void pixelsAnimate(uint8_t r, uint8_t g, uint8_t b, uint16_t lenMillis = 0) {
  pixelsDeltaSteps = lenMillis / PIXELS_TASK_INTERVAL;

  pixelsTargetR = r;
  pixelsTargetG = g;
  pixelsTargetB = b;

  if (pixelsDeltaSteps) {
    int32_t dR = (pixelsTargetR << 8) - pixelsCurrentR;
    int32_t dG = (pixelsTargetG << 8) - pixelsCurrentG;
    int32_t dB = (pixelsTargetB << 8) - pixelsCurrentB;

    pixelsDeltaR = dR / pixelsDeltaSteps;
    pixelsDeltaG = dG / pixelsDeltaSteps;
    pixelsDeltaB = dB / pixelsDeltaSteps;
  } else {
    pixelsCurrentG = pixelsTargetG << 8;
    pixelsCurrentR = pixelsTargetR << 8;
    pixelsCurrentB = pixelsTargetB << 8;

    pixelsUpdate();
  }

  logHeader();
  logRaw("R:");
  logRaw(pixelsTargetR);
  logRaw(", G:");
  logRaw(pixelsTargetG);
  logRaw(", B:");
  logRaw(pixelsTargetB);
  logRaw(", Steps:");
  logRaw(pixelsDeltaSteps);
  logLine();
}

void pixelsUpdate() {
  pixelsSet(pixelsCurrentR >> 8, pixelsCurrentG >> 8, pixelsCurrentB >> 8);
}

void pixelsSet(uint8_t r, uint8_t g, uint8_t b) {
  for (int i = 0; i < PIXELS_BYTE_COUNT; i += 3) {
    pixelsBuffer[i] = g;
    pixelsBuffer[i + 1] = r;
    pixelsBuffer[i + 2] = b;
  }
  espShow(PIXELS_PIN, pixelsBuffer, PIXELS_BYTE_COUNT);
}

