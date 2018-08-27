
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

  if (r == 0 && g == 0 && b == 0) {
    logicSetState(false);
  } else {
    logicSetColor(r, g, b);
  }

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
