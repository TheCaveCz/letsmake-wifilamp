
void serverApiSetWifi() {
  SERVER_AUTH_REQUIRED

  String ssid = server.arg("ssid");
  String pass = server.arg("pass");
  uint16_t ssidLen = ssid.length();
  uint16_t passLen = pass.length();
  if (ssidLen == 0 || ssidLen > 32 || passLen == 0 || passLen > 32) {
    server.send(400, "text/json", "{\"error\":\"Invalid arguments\"}\n");
    return;
  }

  if (wifiSetSsid(ssid, pass)) {
    server.send(204);
  } else {
    server.send(500, "text/json", "{\"error\":\"Unable to store ssid\"}n");
  }
}

void serverApiSetPassword() {
  SERVER_AUTH_REQUIRED

  String pass = server.arg("new");
  String oldPass = server.arg("old");
  uint16_t passLen = pass.length();
  if (passLen < 4 || passLen > 64 || pass == oldPass) {
    server.send(400, "text/json", "{\"error\":\"Password to short or long\"}\n");
    return;
  }
  if (logicConfig.adminPass != oldPass) {
    server.send(400, "text/json", "{\"error\":\"Invalid password\"}\n");
    return;
  }

  if (logicSetAdminPass(pass)) {
    server.send(204);
  } else {
    server.send(500, "text/json", "{\"error\":\"Unable to store password\"}n");
  }
}


void serverApiStatus() {
  SERVER_AUTH_REQUIRED

  String response = "{\"mac\":\"";
  response += WiFi.macAddress();
  response += "\",\"chipid\":";
  response += ESP.getChipId();
  response += ",\"uptime\":";
  response += millis() / 1000L;
  response += ",\"r\":";
  response += logicColorR;
  response += ",\"g\":";
  response += logicColorG;
  response += ",\"b\":";
  response += logicColorB;
  response += ",\"on\":";
  response += logicOn ? "true" : "false";
  response += ",\"ssid\":\"";
  response += wifiConfig.ssid;
  response += "\"}\n";
  server.send(200, "text/json", response);
}

void serverApiGetDefaults() {
  SERVER_AUTH_REQUIRED

  String response = "{\"r\":";
  response += logicConfig.colorR;
  response += ",\"g\":";
  response += logicConfig.colorG;
  response += ",\"b\":";
  response += logicConfig.colorB;
  response += ",\"on\":";
  response += logicConfig.on ? "true" : "false";
  response += "}\n";
  server.send(200, "text/json", response);
}

void serverApiSetDefaults() {
  SERVER_AUTH_REQUIRED

  uint8_t r = server.arg("r").toInt();
  uint8_t g = server.arg("g").toInt();
  uint8_t b = server.arg("b").toInt();
  bool on = server.arg("on").toInt() ? true : false;

  if (logicSetDefaults(r, g, b, on)) {
    serverApiGetDefaults();
  } else {
    server.send(500, "text/json", "{\"error\":\"Unable to store default values\"}n");
  }
}

void serverApiSetColor() {
  SERVER_AUTH_REQUIRED

  uint8_t r = server.arg("r").toInt();
  uint8_t g = server.arg("g").toInt();
  uint8_t b = server.arg("b").toInt();
  uint16_t t = server.arg("time").toInt();

  if (r == 0 && g == 0 && b == 0) {
    logicSetState(false, t);
  } else {
    logicSetColor(r, g, b, t);
  }

  serverApiStatus();
}

void serverApiSetOn() {
  SERVER_AUTH_REQUIRED

  bool on = server.arg("on").toInt() ? true : false;
  uint16_t t = server.arg("time").toInt();
  logicSetState(on, t);

  serverApiStatus();
}

void serverApiReboot() {
  SERVER_AUTH_REQUIRED

  server.send(204);

  ESP.restart();
}

