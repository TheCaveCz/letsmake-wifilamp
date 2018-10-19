
bool blynkFirstConnect;
uint32_t blynkConnectionCheckTime;


BLYNK_CONNECTED() {
  logInfo("Blynk connected");

  if (blynkFirstConnect) {
    // when connected to Blynk stop pulsing LEDs. No effect on subsequent calls.
    timeoutClear();
    blynkFirstConnect = false;
    Blynk.syncAll();
  }
}

BLYNK_DISCONNECTED() {
  logInfo("Blynk disconnected");
}

BLYNK_WRITE(BLYNK_RGB_PIN) {
  logicSetColor(param[0].asInt(), param[1].asInt(), param[2].asInt(), logicBrightness);
}

BLYNK_WRITE(BLYNK_RGB_R_PIN) {
  logicSetColor(param.asInt(), logicColorG, logicColorB, logicBrightness);
}

BLYNK_WRITE(BLYNK_RGB_G_PIN) {
  logicSetColor(logicColorR, param.asInt(), logicColorB, logicBrightness);
}

BLYNK_WRITE(BLYNK_RGB_B_PIN) {
  logicSetColor(logicColorR, logicColorG, param.asInt(), logicBrightness);
}

BLYNK_WRITE(BLYNK_BUTTON_PIN) {
  logicSetState(param.asInt());
}

BLYNK_WRITE(BLYNK_SPEED_PIN) {
  logicTransitionTime = param.asInt() * 100;
}

BLYNK_WRITE(BLYNK_BRIGHTNESS_PIN) {
  logicSetColor(logicColorR, logicColorG, logicColorB, param.asFloat());
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

void blynkCheck() {
  if (!timeoutIsActive() && blynkConnectionCheckTime && millis() > blynkConnectionCheckTime) {
    logInfo("Blynk connection check");
    blynkConnectionCheckTime = millis() + RECONNECT_INTERVAL;
    blynkConnectIfPossible();
  }
}

void blynkSetup() {
  blynkFirstConnect = true;
  Blynk.config(config.blynkToken);
  blynkConnectionCheckTime = blynkIsConfigured() ? millis() + RECONNECT_INTERVAL : 0;

}
