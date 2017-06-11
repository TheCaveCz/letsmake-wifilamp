
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

void setup() {
  Serial.begin(9600);

  logInfo("Starting");
  logValue("Chip id: ", ESP.getChipId());

  buttonSetup();
  pixelsSetup();
  fsSetup();
  logicSetup();

  wifiReadConfig();
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
