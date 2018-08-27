#define BLINKER_MAX_RANGE 40

#define BLINKER_STATE_CONNECTING 0
#define BLINKER_STATE_AP 1
#define BLINKER_STATE_ERROR 2
#define BLINKER_STATE_READY 3

Ticker blinkerTicker;

uint8_t blinkerProgress = 0;
uint8_t blinkerState = BLINKER_STATE_CONNECTING;


void blinkerTick() {
  uint8_t v = blinkerProgress < (BLINKER_MAX_RANGE / 2) ? map(blinkerProgress, 0, (BLINKER_MAX_RANGE / 2) - 1, 32, 128) : map(blinkerProgress, BLINKER_MAX_RANGE / 2, BLINKER_MAX_RANGE - 1, 128, 32);

  switch (blinkerState) {
    case BLINKER_STATE_CONNECTING:
      pixelsSet(0, 0, v);
      break;
    case BLINKER_STATE_AP:
      pixelsSet(v, 0, v);
      break;
    case BLINKER_STATE_READY:
      pixelsSet(0, v, 0);
      break;
    default:
      pixelsSet(v, 0, 0);
      break;
  }

  blinkerProgress++;
  if (blinkerProgress >= BLINKER_MAX_RANGE) blinkerProgress = 0;
}

void blinkerStop() {
  logInfo("Blinker stopped");
  blinkerTicker.detach();
}

void blinkerSet(uint8_t v) {
  logValue("Blinker set to ", v);
  blinkerState = v;
}

void blinkerStart(uint8_t v) {
  blinkerSet(v);
  blinkerTicker.attach(0.05, blinkerTick);
}
