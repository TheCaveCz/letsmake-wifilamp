
ESP8266WebServer server(80);

#define SERVER_AUTH_REQUIRED if (!serverAuthenticateUser()) return;

#if OPTIONS_ENABLED
class OptionsRequestHandler : public RequestHandler {
  public:
    OptionsRequestHandler(const String &uri): _uri(uri) {
    }

    bool canHandle(HTTPMethod requestMethod, String requestUri) override  {
      if (requestMethod == HTTP_OPTIONS) {
        return requestUri.startsWith(_uri);
      } else {
        return false;
      }
    }

    bool canUpload(String requestUri) override  {
      return false;
    }

    bool handle(ESP8266WebServer& server, HTTPMethod requestMethod, String requestUri) override {
      (void) server;
      if (!canHandle(requestMethod, requestUri))
        return false;

      server.sendHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
      server.sendHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
      //server.sendHeader("Access-Control-Allow-Origin", "*");
      server.send(200);
      return true;
    }

    void upload(ESP8266WebServer& server, String requestUri, HTTPUpload& upload) override {

    }

  protected:
    String _uri;
};
#endif

void serverSetup() {
  server.serveStatic("/", SPIFFS, "/web/index.html");
  server.serveStatic("/settings", SPIFFS, "/web/index.html");
  server.serveStatic("/settings/connect", SPIFFS, "/web/index.html");
  server.serveStatic("/login", SPIFFS, "/web/index.html");
  server.serveStatic("/bundle.js", SPIFFS, "/web/bundle.js");
  server.serveStatic("/style.css", SPIFFS, "/web/style.css");
  server.serveStatic("/favicon.ico", SPIFFS, "/web/favicon.ico");
  server.serveStatic("/header.png", SPIFFS, "/web/header.png");

#if OPTIONS_ENABLED
  server.addHandler(new OptionsRequestHandler("/api/"));
#endif

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
    //server.sendHeader("WWW-Authenticate", "Basic realm=\"Login Required\"");
    server.send(401, "text/json", "{\"error\":\"Login required\"}\n");
    return false;
  }
}

