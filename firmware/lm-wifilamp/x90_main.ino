
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
  blynkSetup();
  logInfo("Ready to go!");
  timeoutRefresh();
}

void loop() {
  if (Blynk.connected()) {
    Blynk.run();
  }

  ArduinoOTA.handle();
  server.handleClient();
  logicButtonTask();

  if (wifiGotIpFlag) {
    wifiGotIpFlag = false;

    if (blynkIsConfigured()) {
      // we have blynk token, try to connect there
      pixelsSetAnimState(PIXELS_ANIM_GREEN);
      timeoutRefresh();
      blynkConnectIfPossible();
    } else {
      // if we don't have blynk token stop pulsing LEDs.
      timeoutClear();
    }
  }

  timeoutCheck();
  blynkCheck();
}
