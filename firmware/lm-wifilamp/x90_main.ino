
BLYNK_CONNECTED() {
  // when connected to Blynk stop pulsing LEDs. No effect on subsequent calls.
  blinkerStop();

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


void setup() {
  Serial.begin(115200);

  logInfo("Starting");
  logValue("Chip id: ", chipId);

  buttonSetup();
  pixelsSetup();

  logicSetup();

  configSetup();
  otaSetup();
  wifiSetup();
  serverSetup();

  Blynk.config(config.blynkToken);

  logInfo("Ready to go!");
}

void loop() {
  if (Blynk.connected()) {
    Blynk.run();
  }

  ArduinoOTA.handle();
  server.handleClient();
  if (!blinkerActive()) {
    pixelsTask();
  }
  logicButtonTask();

  if (wifiGotIpFlag) {
    wifiGotIpFlag = false;

    if (strlen(config.blynkToken)) {
      // we have blynk token, try to connect there
      blinkerSet(BLINKER_STATE_READY);
      Blynk.connect();
    } else {
      // if we don't have blynk token set stop pulsing LEDs.
      blinkerStop();
    }
  }

  // TODO : handle reconnect when blynk connection is lost/broken
}
