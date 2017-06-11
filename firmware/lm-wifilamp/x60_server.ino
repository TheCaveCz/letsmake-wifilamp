
ESP8266WebServer server(80);

void setupServer() {
  server.on("/", serverHandleRoot);
  server.on("/setColor", serverSetColor);
  server.begin();
}

void serverHandleRoot() {
  String response = "mac=";
  response += WiFi.macAddress();
  response += "\nuptime=";
  response += millis() / 1000L;
  response += "\nr=";
  response += pixelsR;
  response += "\ng=";
  response += pixelsG;
  response += "\nb=";
  response += pixelsB;
  response += '\n';
  server.send(200, "text/plain", response);
}

void serverSetColor() {
  uint8_t r = server.arg("r").toInt();
  uint8_t g = server.arg("g").toInt();
  uint8_t b = server.arg("b").toInt();

  pixelsSet(r,g,b);

  String response = "r=";
  response += pixelsR;
  response += "\ng=";
  response += pixelsG;
  response += "\nb=";
  response += pixelsB;
  response += '\n';
  server.send(200, "text/plain", response);
}

