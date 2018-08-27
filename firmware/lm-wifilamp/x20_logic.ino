

uint8_t logicColorR;
uint8_t logicColorG;
uint8_t logicColorB;
bool logicOn;

uint32_t logicButtonTaskTime;
uint32_t logicButtonTaskInterval;

uint8_t logicButtonCounter;

uint16_t logicTransitionTime;


void logicSetup() {
  logicButtonCounter = 0;

  logicColorR = 255;
  logicColorG = 255;
  logicColorB = 255;
  logicOn = false;

  logicTransitionTime = 0;

  logicButtonTaskTime = 0;
  logicButtonTaskInterval = LOGIC_BUTTON_TASK_INTERVAL;
}

void logicUpdatePixels() {
  if (logicOn) {
    pixelsAnimate(logicColorR, logicColorG, logicColorB, logicTransitionTime);
  } else {
    pixelsAnimate(0, 0, 0, logicTransitionTime);
  }
}

bool logicSetState(const bool on) {
  if (logicOn == on) return false;
  logValue("Logic state ", on);
  logicOn = on;
  logicUpdatePixels();

  if (Blynk.connected()) {
    Blynk.virtualWrite(BLYNK_BUTTON_PIN, on);
  }

  return true;
}

void logicSetColor(const uint8_t r, const uint8_t g, const uint8_t b) {
  if (logicColorR == r && logicColorG == g && logicColorB == b) return;

  logicColorR = r;
  logicColorG = g;
  logicColorB = b;

  if (Blynk.connected()) {
    Blynk.virtualWrite(BLYNK_RGB_PIN, r, g, b);
    Blynk.virtualWrite(BLYNK_RGB_R_PIN, r);
    Blynk.virtualWrite(BLYNK_RGB_G_PIN, g);
    Blynk.virtualWrite(BLYNK_RGB_B_PIN, b);
  }

  if (logicOn) {
    logicUpdatePixels();
  }
}

void logicButtonTask() {
  uint32_t now = millis();
  if (now - logicButtonTaskTime < logicButtonTaskInterval) return;
  logicButtonTaskTime = now;
  logicButtonTaskInterval = LOGIC_BUTTON_TASK_INTERVAL;


  if (logicButtonCounter >= 10) {
    logicButtonCounter = buttonReadRaw() ? logicButtonCounter + 1 : 0;
    if (logicButtonCounter == 0) {
      logicButtonTaskInterval = LOGIC_BUTTON_LOCKUP_TIME;
    } else if (logicButtonCounter >= 10 + 160) { // 10 is offset, 160 is 8 seconds (50ms*160 cycles)
      wifiResetAndRestart();
    }
  } else {
    logicButtonCounter = buttonReadRaw() ? logicButtonCounter + 1 : 0;
    if (logicButtonCounter >= 3) {
      logicSetState(!logicOn);

      logicButtonCounter = 10;
    }
  }
}
