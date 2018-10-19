
void serverApiStatus() {
  SERVER_AUTH_REQUIRED

  String response = "{\"fwVersion\":\"" FW_VERSION "\",\"chipid\":\"";
  response += chipId;
  response += "\",\"uptime\":";
  response += millis() / 1000L;
  response += ",\"r\":";
  response += logicColorR;
  response += ",\"g\":";
  response += logicColorG;
  response += ",\"b\":";
  response += logicColorB;
  response += ",\"brightness\":";
  response += logicBrightness;
  response += ",\"on\":";
  response += logicOn ? "true" : "false";
  response += ",\"mac\":\"";
  response += WiFi.macAddress();
  response += "\",\"ip\":\"";
  response += WiFi.localIP().toString();
  response += "\"}\n";

  server.send(200, "text/json", response);
}

void serverApiSetColor() {
  SERVER_AUTH_REQUIRED

  uint8_t r = server.arg("r").toInt();
  uint8_t g = server.arg("g").toInt();
  uint8_t b = server.arg("b").toInt();
  float brightness = server.hasArg("brightness") ? server.arg("brightness").toFloat() : logicBrightness;

  if ((r == 0 && g == 0 && b == 0) || (brightness <= 0 || brightness > 1)) {
    server.send(400, "text/json", "{\"error\":\"Invalid value\"}\n");
    return;
  }
  
  logicSetColor(r, g, b, brightness);
  serverApiStatus();
}

void serverApiSetBrightness() {
  SERVER_AUTH_REQUIRED

  float brightness = server.arg("brightness").toFloat();
  if (brightness <= 0 || brightness > 1) {
    server.send(400, "text/json", "{\"error\":\"Invalid value\"}\n");
    return;
  }
  logicSetColor(logicColorR, logicColorG, logicColorB, brightness);

  serverApiStatus();
}

void serverApiSetOn() {
  SERVER_AUTH_REQUIRED

  bool on = server.arg("on").toInt() ? true : false;
  logicSetState(on);

  serverApiStatus();
}

void serverApiReboot() {
  SERVER_AUTH_REQUIRED

  server.send(200, "text/json", "{\"reboot\":true}\n");

  ESP.restart();
}
