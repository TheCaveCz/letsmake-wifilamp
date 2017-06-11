void setupOta() {
  // Port defaults to 8266
  // ArduinoOTA.setPort(8266);

  // Hostname defaults to esp8266-[ChipID]
  ArduinoOTA.setHostname(CFG_HOSTNAME);

  // No authentication by default
  //ArduinoOTA.setPassword("pass");

  ArduinoOTA.onStart([]() {
    pixelsSet(0, 0, 0);
    pixelTask.disable();
  });
//  ArduinoOTA.onError([](ota_error_t error) {
//    DBGPV("OTA update error: ", error);
//  });
  ArduinoOTA.begin();
}
