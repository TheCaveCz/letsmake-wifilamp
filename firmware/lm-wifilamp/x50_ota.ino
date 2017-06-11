void otaSetup() {

  String ssid = WIFI_AP_PREFIX;
  ssid += ESP.getChipId();
  ArduinoOTA.setHostname(ssid.c_str());

  // No authentication by default
  //ArduinoOTA.setPassword("pass");

  ArduinoOTA.onStart([]() {
    pixelsSet(0, 0, 0);
  });
  //  ArduinoOTA.onError([](ota_error_t error) {
  //    DBGPV("OTA update error: ", error);
  //  });
  ArduinoOTA.begin();
}
