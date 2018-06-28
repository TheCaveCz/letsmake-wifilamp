
#define MASTER_RESET_DELAY 20
#define MASTER_RESET_COUNTER 200

#define WIFI_CONF_MAGIC 0x42

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

  char token[64];
  memset(token, 0, sizeof(token));
  wifiBlynkToken.toCharArray(token, sizeof(token) - 1);

  EEPROM.write(0, WIFI_CONF_MAGIC);
  EEPROM.put(1, token);
  EEPROM.commit();

  return true;
}

void wifiReadConfig() {
  logInfo("Reading wifi config");

  uint8_t magic = EEPROM.read(0);

  if (magic == WIFI_CONF_MAGIC) {
    char token[64];
    memset(token, 0, sizeof(token));
    EEPROM.get(1, token);

    wifiBlynkToken = String(token);
  } else {
    logInfo("Unable to open wifi config");
    wifiBlynkToken = BLYNK_DEFAULT_TOKEN;
    wifiWriteConfig();
  }

  logValue(" blynk token: ", wifiBlynkToken);
}

void wifiConnect() {
  WiFiManager wifiManager;

  if (buttonReadRaw() && wifiAttemptMasterReset()) {
    wifiManager.resetSettings();
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

