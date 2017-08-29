
void otaUpdatePassword() {
#if OTA_REQUIRES_PASSWORD
  ArduinoOTA.setPassword(logicConfig.adminPass.c_str());
#endif
}

void otaSetup() {
  String name = "The Cave WiFi lamp (";
  name += chipId;
  name += ")";
  
  MDNS.setInstanceName(name);
  
  String ssid = HOSTNAME_PREFIX;
  ssid += chipId;
  ArduinoOTA.setHostname(ssid.c_str());

  otaUpdatePassword();
  
  ArduinoOTA.onStart([]() {
    pixelsSet(0, 0, 0);
  });
  ArduinoOTA.begin();
}
