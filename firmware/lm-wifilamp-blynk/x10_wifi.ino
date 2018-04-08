
#define MASTER_RESET_DELAY 20
#define MASTER_RESET_COUNTER 200


bool wifiShouldSaveConfig = false;
String wifiBlynkToken;


bool wifiAttemptMasterReset() {
  logInfo("Testing button for master reset");
  pixelsSet(0, 0, 255);

  uint16_t counter = 0;
  while (counter < MASTER_RESET_COUNTER) {
    counter = buttonReadRaw() ? counter + 1 : 0;
    pixelsSet(map(counter, 0, MASTER_RESET_COUNTER, 0, 255), 0, 255);
    if (counter == 0) {
      logInfo("Button released before master reset");
      return false;
    }
    delay(MASTER_RESET_DELAY);
  }

  logInfo("Master reset");
  return true;
}

bool wifiWriteConfig() {
  logInfo("Writing WiFi config");
  File cfg = SPIFFS.open(WIFI_CONF_FILE, "w");
  if (!cfg) {
    logInfo("Unable to create config");
    return false;
  }

  cfg.print(wifiBlynkToken);
  cfg.write('\n');
  cfg.close();

  return true;
}

void wifiResetConfig() {
  wifiBlynkToken = "";
  wifiWriteConfig();
}

void wifiReadConfig() {
  logInfo("Reading wifi config");
  File cfg = SPIFFS.open(WIFI_CONF_FILE, "r");
  if (cfg) {
    wifiBlynkToken = cfg.readStringUntil('\n');
    cfg.close();
  } else {
    logInfo("Unable to open wifi config");
    wifiResetConfig();
  }

  logValue(" blynk token: ", wifiBlynkToken);
}

void wifiConnect() {
  WiFiManager wifiManager;

  if (buttonReadRaw() && wifiAttemptMasterReset()) {
    wifiManager.resetSettings();
    wifiResetConfig();
  }

  blinkerStart(BLINKER_STATE_CONNECTING);

  wifiReadConfig();

  wifiManager.setAPCallback([](WiFiManager * myWiFiManager) {
    logInfo("Entered config mode");
    logValue("  config SSID: ", myWiFiManager->getConfigPortalSSID());
    blinkerSet(BLINKER_STATE_AP);
  });
  wifiManager.setSaveConfigCallback([]() {
    logInfo("Config should be saved");
    wifiShouldSaveConfig = true;
  });

  WiFiManagerParameter blynkTokenParam("token", "Blynk Auth token", wifiBlynkToken.c_str(), 33);
  wifiManager.addParameter(&blynkTokenParam);

  String ssid = HOSTNAME_PREFIX;
  ssid += chipId;
  if (!wifiManager.autoConnect(ssid.c_str())) {
    logInfo("Waiting for button press for reboot");
    blinkerSet(BLINKER_STATE_ERROR);
    while (!buttonReadRaw()) {
      yield();
    }
    ESP.restart();
    while (1) {}
  }

  logInfo("Connected successfuly");
  logValue("IP address: ", WiFi.localIP());

  wifiBlynkToken = String(blynkTokenParam.getValue());

  if (wifiShouldSaveConfig) {
    wifiWriteConfig();
  }

  // this will keep the lights pulsing in green until blinkerStop() is called
  blinkerSet(BLINKER_STATE_READY);
}

