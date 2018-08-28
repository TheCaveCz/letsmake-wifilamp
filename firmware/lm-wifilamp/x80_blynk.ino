
BLYNK_CONNECTED() {
  logInfo("Blynk connected");
  // when connected to Blynk stop pulsing LEDs. No effect on subsequent calls.
  timeoutClear();

  Blynk.syncAll();
}

BLYNK_WRITE(BLYNK_RGB_PIN) {
  logicSetColor(param[0].asInt(), param[1].asInt(), param[2].asInt());
}

BLYNK_WRITE(BLYNK_RGB_R_PIN) {
  logicSetColor(param.asInt(), logicColorG, logicColorB);
}

BLYNK_WRITE(BLYNK_RGB_G_PIN) {
  logicSetColor(logicColorR, param.asInt(), logicColorB);
}

BLYNK_WRITE(BLYNK_RGB_B_PIN) {
  logicSetColor(logicColorR, logicColorG, param.asInt());
}

BLYNK_WRITE(BLYNK_BUTTON_PIN) {
  logicSetState(param.asInt());
}

BLYNK_WRITE(BLYNK_SPEED_PIN) {
  logicTransitionTime = param.asInt() * 100;
}

bool blynkIsConfigured() {
  return strlen(config.blynkToken) != 0;
}

void blynkConnectIfPossible() {
  if (WiFi.isConnected() && !Blynk.connected()) {
    logInfo("Blynk connect attempt");
    Blynk.connect();
  }
}

uint32_t blynkConnectionCheckTime;

void blynkCheck() {
  if (!timeoutIsActive() && blynkConnectionCheckTime && millis() > blynkConnectionCheckTime) {
    logInfo("Blynk connection check");
    blynkConnectionCheckTime = millis() + RECONNECT_INTERVAL;
    blynkConnectIfPossible();
  }
}

void blynkSetup() {
  Blynk.config(config.blynkToken);
  blynkConnectionCheckTime = blynkIsConfigured() ? millis() + RECONNECT_INTERVAL : 0;

}
