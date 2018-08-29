#define PIXELS_BYTE_COUNT (PIXELS_COUNT * 3)
#define PIXELS_TASK_INTERVAL 25UL
#define PIXELS_ANIM_MAX_RANGE 80

#define PIXELS_ANIM_BLUE 0
#define PIXELS_ANIM_VIOLET 1
#define PIXELS_ANIM_RED 2
#define PIXELS_ANIM_GREEN 3
#define PIXELS_ANIM_NORMAL 4


uint16_t pixelsCurrentG;
uint16_t pixelsCurrentR;
uint16_t pixelsCurrentB;

uint8_t pixelsTargetG;
uint8_t pixelsTargetR;
uint8_t pixelsTargetB;

int16_t pixelsDeltaG;
int16_t pixelsDeltaR;
int16_t pixelsDeltaB;

uint8_t pixelsBuffer[PIXELS_BYTE_COUNT];

Ticker pixelsTicker;

uint16_t pixelsProgress;
uint8_t pixelsState;


void pixelsSet(uint8_t r, uint8_t g, uint8_t b) {
  for (int i = 0; i < PIXELS_BYTE_COUNT; i += 3) {
    pixelsBuffer[i] = g;
    pixelsBuffer[i + 1] = r;
    pixelsBuffer[i + 2] = b;
  }

  ws2812Send(pixelsBuffer, PIXELS_BYTE_COUNT);
}

void pixelsCalculateAnimationStep() {
  if (pixelsProgress) {
    pixelsProgress--;
    if (pixelsProgress) {
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
  }
  pixelsSet(pixelsCurrentR >> 8, pixelsCurrentG >> 8, pixelsCurrentB >> 8);
}

void pixelsTick() {
  if (pixelsState == PIXELS_ANIM_NORMAL) {
    pixelsCalculateAnimationStep();
    return;
  }

  uint8_t v = pixelsProgress < (PIXELS_ANIM_MAX_RANGE / 2)
              ? map(pixelsProgress, 0, (PIXELS_ANIM_MAX_RANGE / 2) - 1, 4, 128)
              : map(pixelsProgress, PIXELS_ANIM_MAX_RANGE / 2, PIXELS_ANIM_MAX_RANGE - 1, 128, 4);

  switch (pixelsState) {
    case PIXELS_ANIM_BLUE:
      pixelsSet(0, 0, v);
      break;
    case PIXELS_ANIM_VIOLET:
      pixelsSet(v, 0, v);
      break;
    case PIXELS_ANIM_GREEN:
      pixelsSet(0, v, 0);
      break;
    default:
      pixelsSet(v, 0, 0);
      break;
  }

  pixelsProgress++;
  if (pixelsProgress >= PIXELS_ANIM_MAX_RANGE) pixelsProgress = 0;
}

void pixelsStartAnimation(uint8_t r, uint8_t g, uint8_t b, uint16_t lenMillis = 0) {
  pixelsProgress = lenMillis / PIXELS_TASK_INTERVAL;

  pixelsTargetR = r;
  pixelsTargetG = g;
  pixelsTargetB = b;

  if (pixelsProgress) {
    int32_t dR = (pixelsTargetR << 8) - pixelsCurrentR;
    int32_t dG = (pixelsTargetG << 8) - pixelsCurrentG;
    int32_t dB = (pixelsTargetB << 8) - pixelsCurrentB;

    pixelsDeltaR = dR / pixelsProgress;
    pixelsDeltaG = dG / pixelsProgress;
    pixelsDeltaB = dB / pixelsProgress;
  } else {
    pixelsCurrentG = pixelsTargetG << 8;
    pixelsCurrentR = pixelsTargetR << 8;
    pixelsCurrentB = pixelsTargetB << 8;
  }
}

void pixelsSetAnimState(uint8_t v) {
  if (pixelsState == PIXELS_ANIM_NORMAL) return;

  logValue("Pixels anim state set to ", v);
  pixelsState = v;
}

void pixelsSetup() {
  ws2812Setup();

  pixelsSet(0, 0, 0);

  pixelsProgress = 0;
  pixelsState = PIXELS_ANIM_BLUE;
  pixelsTicker.attach_ms(PIXELS_TASK_INTERVAL, pixelsTick);
}
