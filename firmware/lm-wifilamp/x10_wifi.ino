
struct WifiConfig {
  uint8_t connected;
  String ssid;
  String pass;
  uint8_t apMode;
} wifiConfig;


/*
    WL_IDLE_STATUS      = 0,
    WL_NO_SSID_AVAIL    = 1,
    WL_SCAN_COMPLETED   = 2,
    WL_CONNECTED        = 3,
    WL_CONNECT_FAILED   = 4,
    WL_CONNECTION_LOST  = 5,
    WL_DISCONNECTED     = 6
*/

void wifiConnectedCb();
void wifiStartedApCb();

void wifiReadConfig() {
  logInfo("Reading wifi config");
  File cfg = SPIFFS.open(WIFI_CONF_FILE, "r");
  if (cfg) {
    wifiConfig.connected = cfg.readStringUntil('\n').toInt();
    if (wifiConfig.connected) {
      wifiConfig.ssid = cfg.readStringUntil('\n');
      wifiConfig.pass = cfg.readStringUntil('\n');
    } else {
      wifiConfig.ssid = "";
      wifiConfig.pass = "";
    }
    cfg.close();
  } else {
    logInfo("Unable to open wifi config");
    wifiConfig.connected = false;
    wifiConfig.ssid = "";
    wifiConfig.pass = "";
  }

  logValue(" connected: ", wifiConfig.connected);
  logValue(" ssid: ", wifiConfig.ssid);
  logValue(" pass: ", wifiConfig.pass);

}

bool wifiSetSsid(const String& ssid, const String& pass) {
  logInfo("Writing WiFi config");
  File cfg = SPIFFS.open(WIFI_CONF_FILE, "w");
  if (!cfg) {
    logInfo("Unable to create config");
    return false;
  }

  wifiConfig.ssid = ssid;
  wifiConfig.pass = pass;
  wifiConfig.connected = 1;

  cfg.write('1');
  cfg.write('\n');
  cfg.print(ssid);
  cfg.write('\n');
  cfg.print(pass);
  cfg.write('\n');

  cfg.close();
  return true;
}

void wifiConnectSta() {
  logInfo("Connecting STA");
  pixelsSet(0, 0, 255);
  wifiConfig.apMode = 0;

  if (WiFi.getMode() != WIFI_STA) WiFi.mode(WIFI_STA);
  if (WiFi.getAutoConnect()) WiFi.setAutoConnect(false);
  WiFi.setAutoReconnect(true);
  WiFi.begin(wifiConfig.ssid.c_str(), wifiConfig.pass.c_str());

  int counter = 0;
  while (WiFi.status() != WL_CONNECTED) {
    logRaw('.');
    pixelsSet(0, 0, 32);
    delay(WIFI_CONNECT_DELAY / 2);
    pixelsSet(0, 0, 128);
    delay(WIFI_CONNECT_DELAY / 2);
    counter++;
    if (counter > WIFI_CONNECT_COUNTER) {
      logRaw("Connect timed out");
      break;
    }
  }
  logLine();

  logValue("Connect status: ", WiFi.status());
  if (WiFi.status() == WL_CONNECTED) {
    logInfo("Connected successfuly");
    logValue("IP address: ", WiFi.localIP());
    wifiConnectedCb();
  } else {
    wifiWaitForButton();
  }
}

void wifiWaitForButton() {
  logInfo("Waiting for button press for AP mode");
  pixelsSet(255, 0, 0);

  uint8_t counter = 0;
  while (counter < WIFI_ENTER_AP_COUNTER) {
    counter = buttonReadRaw() ? counter + 1 : 0;
    pixelsSet(255, 0, map(counter, 0, WIFI_ENTER_AP_COUNTER, 0, 128));
    delay(WIFI_ENTER_AP_DELAY);
  }

  wifiConnectAp();
}

void wifiConnectAp() {
  logInfo("Starting AP mode");
  pixelsSet(255, 0, 255);
  wifiConfig.apMode = 1;

  if (WiFi.getMode() != WIFI_AP) WiFi.mode(WIFI_AP);

  String ssid = WIFI_AP_PREFIX;
  ssid += ESP.getChipId();
  if (!WiFi.softAP(ssid.c_str(), WIFI_AP_PASSWORD)) {
    bail("FATAL: softAP");
    return;
  }

  WiFi.scanNetworks(true);

  wifiStartedApCb();
}

void wifiConnect() {
  WiFi.persistent(false); // avoid rewriting ssid/pass in flash

  if (wifiConfig.connected) {
    wifiConnectSta();
  } else {
    wifiConnectAp();
  }
}

