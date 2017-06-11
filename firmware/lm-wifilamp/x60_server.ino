
ESP8266WebServer server(80);

#define SERVER_AUTH_REQUIRED if (!serverAuthenticateUser()) return;

void serverSetup() {
  server.on("/", []() {
    serverSendFile("/web/index.html");
  });

#if LOG_ENABLED
  server.on("/log", HTTP_GET, []() {
    logBuffer.dumpTo(&server);
  });
#endif

  server.on("/api/status", HTTP_GET, serverApiStatus);
  server.on("/api/color", HTTP_POST, serverApiSetColor);
  server.on("/api/on", HTTP_POST, serverApiSetOn);
  server.on("/api/wifi", HTTP_POST, serverApiSetWifi);
  server.on("/api/password", HTTP_POST, serverApiSetPassword);

  server.on("/api/defaults", HTTP_POST, serverApiSetDefaults);
  server.on("/api/defaults", HTTP_GET, serverApiGetDefaults);

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
    server.send(401, "text/plain", "Login required\n");
    return false;
  }
}

String serverGetContentType(const String& filename) {
  if (filename.endsWith(".htm")) return "text/html";
  else if (filename.endsWith(".html")) return "text/html";
  else if (filename.endsWith(".css")) return "text/css";
  else if (filename.endsWith(".js")) return "application/javascript";
  else if (filename.endsWith(".png")) return "image/png";
  else if (filename.endsWith(".jpg")) return "image/jpeg";
  else if (filename.endsWith(".ico")) return "image/x-icon";
  else if (filename.endsWith(".gz")) return "application/x-gzip";
  return "text/plain";
}

void serverSendFile(const String& path) {
  File file = SPIFFS.open(path, "r");
  size_t s = file.size();
  size_t sent = server.streamFile(file, serverGetContentType(path));
  if (s != sent) {
    logValue("Sent less bytes: ", path);
  }
  file.close();
}


