
void fsSetup() {
  logInfo("Setup filesystem");

  if (!SPIFFS.begin()) {
    bail("FATAL: spiffs init");
    return;
  }
}

void wifiConnectedCb() {
  pixelsAnimate(0, 0, 128);
  logicUpdatePixels(logicConfig.defaultTurnOnSpeed);
}

void wifiStartedApCb() {
  logicSetColor(255, 0, 255, 0);
  logicSetState(true, 0);
}

void attemptMasterReset() {
  logInfo("Testing button for master reset");
  pixelsSet(0, 0, 255);

  uint16_t counter = 0;
  while (counter < MASTER_RESET_COUNTER) {
    counter = buttonReadRaw() ? counter + 1 : 0;
    pixelsSet(0, map(counter, 0, MASTER_RESET_COUNTER, 0, 255), 255);
    if (counter == 0) {
      logInfo("Button released before master reset");
      return;
    }
    delay(MASTER_RESET_DELAY);
  }

  logInfo("Master reset");
  wifiResetConfig();
  logicResetConfig();
}

void setup() {
  Serial.begin(9600);

  logInfo("Starting");
  logValue("Chip id: ", chipId);

  buttonSetup();
  pixelsSetup();
  fsSetup();

  logicSetup();
  wifiReadConfig();

  if (buttonReadRaw()) {
    attemptMasterReset();
  }

  wifiConnect(); // this call won't return unless somehow connected

  otaSetup();
  serverSetup();
}

void loop() {
  ArduinoOTA.handle();
  server.handleClient();

  pixelsTask();
  logicButtonTask();
}
