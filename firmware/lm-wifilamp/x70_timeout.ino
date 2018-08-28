uint32_t timeoutTime;


void timeoutRefresh() {
  timeoutTime = millis() + TIMEOUT_INTERVAL;
}

void timeoutClear() {
  pixelsSetAnimState(PIXELS_ANIM_NORMAL);
  timeoutTime = 0;
}

void timeoutCheck() {
  if (timeoutTime && (millis() > timeoutTime)) {
    logInfo("Timeout reached, disabling animations");
    timeoutClear();
  }
}

bool timeoutIsActive() {
  return timeoutTime != 0;
}
