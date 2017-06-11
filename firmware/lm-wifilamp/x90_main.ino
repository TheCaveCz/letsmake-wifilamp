void setup() {
  Serial.begin(9600);

  pixelsSetup();
  setupWifi();
  setupOta();
  setupServer();
}

void loop() {
  ArduinoOTA.handle();
  server.handleClient();
  scheduler.execute();
}
