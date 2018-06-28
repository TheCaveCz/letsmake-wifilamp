
void otaSetup() {
  String name = "The Cave WiFi lamp (";
  name += chipId;
  name += ")";
  
  MDNS.setInstanceName(name);
  
  String ssid = HOSTNAME_PREFIX;
  ssid += chipId;
  ArduinoOTA.setHostname(ssid.c_str());

#ifdef OTA_PASSWORD
  ArduinoOTA.setPassword(OTA_PASSWORD);
#endif
  
  ArduinoOTA.onStart([]() {
    pixelsSet(0, 0, 0);
  });
  ArduinoOTA.begin();
}
