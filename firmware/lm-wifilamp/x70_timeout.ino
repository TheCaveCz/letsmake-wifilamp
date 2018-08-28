//
// This ensures Lamp will transition from initial blinking animations to normal
// mode where user can turn it on or off in case of failed wifi/blynk connection.
//

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
