
void otaUpdatePassword() {
#if OTA_REQUIRES_PASSWORD
  ArduinoOTA.setPassword(logicConfig.adminPass.c_str());
#endif
}

void otaSetup() {
  String ssid = WIFI_AP_PREFIX;
  ssid += chipId;
  ArduinoOTA.setHostname(ssid.c_str());

  otaUpdatePassword();
  
  ArduinoOTA.onStart([]() {
    pixelsSet(0, 0, 0);
  });
  ArduinoOTA.begin();
}
