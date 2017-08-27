
ESP8266WebServer server(80);

#define SERVER_AUTH_REQUIRED if (!serverAuthenticateUser()) return;

void serverSetup() {
  server.serveStatic("/", SPIFFS, "/web/index.html");
  server.serveStatic("/settings", SPIFFS, "/web/index.html");
  server.serveStatic("/settings/connect", SPIFFS, "/web/index.html");
  server.serveStatic("/login", SPIFFS, "/web/index.html");
  server.serveStatic("/bundle.js", SPIFFS, "/web/bundle.js");
  server.serveStatic("/style.css", SPIFFS, "/web/style.css");
  server.serveStatic("/favicon.ico", SPIFFS, "/web/favicon.ico");
  server.serveStatic("/header.png", SPIFFS, "/web/header.png");

#if LOG_ENABLED
  server.on("/log", HTTP_GET, []() {
    logBuffer.dumpTo(&server);
  });
#endif

  server.on("/api/status", HTTP_GET, serverApiStatus);
  server.on("/api/statusShort", HTTP_GET, serverApiShortStatus);

  server.on("/api/color", HTTP_POST, serverApiSetColor);
  server.on("/api/on", HTTP_POST, serverApiSetOn);

  server.on("/api/wifi", HTTP_POST, serverApiSetWifi);
  server.on("/api/config", HTTP_POST, serverApiSetConfig);

  server.on("/api/scan", HTTP_GET, serverApiGetScan);
  server.on("/api/scan", HTTP_POST, serverApiStartScan);

  server.on("/api/reboot", HTTP_POST, serverApiReboot);

  server.begin();
}

bool serverAuthenticateUser() {
  if (logicConfig.adminPass.length() == 0 || server.authenticate("admin", logicConfig.adminPass.c_str())) {
    return true;
  } else {
    server.sendHeader("WWW-Authenticate", "Basic realm=\"Login Required\"");
    server.send(401, "text/json", "{\"error\":\"Login required\"}\n");
    return false;
  }
}

