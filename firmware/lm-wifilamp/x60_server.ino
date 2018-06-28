
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

void serverApiStatus();
void serverApiSetColor();
void serverApiSetOn();
void serverApiReboot();

void serverSetup() {
  
#if OPTIONS_ENABLED
  server.addHandler(new OptionsRequestHandler("/api/"));
#endif

  server.on("/api/status", HTTP_GET, serverApiStatus);

  server.on("/api/color", HTTP_POST, serverApiSetColor);
  server.on("/api/on", HTTP_POST, serverApiSetOn);

  server.on("/api/reboot", HTTP_POST, serverApiReboot);

  server.begin();
}

bool serverAuthenticateUser() {
  if (server.authenticate("admin", API_PASSWORD)) {
    return true;
  } else {
    server.send(401, "text/json", "{\"error\":\"Login required\"}\n");
    return false;
  }
}

