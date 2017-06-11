
void setupWifi() {
  pixelsSet(0, 0, 255);

  if (WiFi.getMode() != WIFI_STA) WiFi.mode(WIFI_STA);
  if (WiFi.getAutoConnect()) WiFi.setAutoConnect(false);
  WiFi.persistent(false); // avoid rewriting ssid/pass in flash
  WiFi.begin(CFG_SSID, CFG_PWD);

  int counter = 0;
  while (WiFi.status() != WL_CONNECTED) {
    pixelsSet(0,0,32);
    delay(250);
    pixelsSet(0,0,128);
    delay(250);
    counter++;
    if (counter > 30) {
      pixelsSet(255, 0, 0);
      break;
    }
  }

  if (WiFi.status() == WL_CONNECTED) {
    pixelsSet(255, 255, 255);
    pixelTask.enable();
  }
}

