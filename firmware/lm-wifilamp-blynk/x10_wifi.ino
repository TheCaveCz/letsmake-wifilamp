
bool wifiConnectInternal() {
  logInfo("Connecting to '" WIFI_SSID "'");
  pixelsSet(0, 0, 255);

  if (WiFi.getMode() != WIFI_STA) WiFi.mode(WIFI_STA);
  if (WiFi.getAutoConnect()) WiFi.setAutoConnect(false);
  WiFi.setAutoReconnect(true);

#ifdef WIFI_PASS
  WiFi.begin(WIFI_SSID, WIFI_PASS);
#else
  WiFi.begin(WIFI_SSID);
#endif

  int counter = 0;
  while (WiFi.status() != WL_CONNECTED) {
    logRaw('.');
    pixelsSet(0, 0, 32);
    delay(WIFI_CONNECT_DELAY / 2);
    pixelsSet(0, 0, 128);
    delay(WIFI_CONNECT_DELAY / 2);
    counter++;
    if (counter > WIFI_CONNECT_COUNTER) {
      logRaw("Connect timed out\n");
      return false;
    }
  }
  logLine();
  return true;
}

void wifiWaitForButton() {
  logInfo("Waiting for button press for reconnect");
  while (!buttonReadRaw() && WiFi.status() != WL_CONNECTED) {
    pixelsSet(32, 0, 0);
    delay(WIFI_CONNECT_DELAY / 2);
    pixelsSet(128, 0, 0);
    delay(WIFI_CONNECT_DELAY / 2);
  }
}

void wifiConnect() {
  while (WiFi.status() != WL_CONNECTED) {
    if (wifiConnectInternal()) {
      logInfo("Connected successfuly");
      logValue("IP address: ", WiFi.localIP());
    } else {
      logValue("Connect status: ", WiFi.status());
      wifiWaitForButton();
    }
  }
}

