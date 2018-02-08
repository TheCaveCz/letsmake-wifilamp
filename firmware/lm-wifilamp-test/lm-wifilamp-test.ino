#include <ESP8266WiFi.h>
#include <ArduinoOTA.h>

#define WIFI_PASS "put password here"


// Enable if you are using touch sensor instead of classic button.
#define TOUCH_BUTTON 1


#define PIXELS_COUNT 15
#define PIXELS_BYTE_COUNT (PIXELS_COUNT * 3)

#define BUTTON_PIN D5

void uartSetup();
void uartSend(const uint8_t *pixels, uint32_t bytesCount);


void pixelsSet(uint8_t r, uint8_t g, uint8_t b) {
  uint8_t pixelsBuffer[PIXELS_BYTE_COUNT];
  for (int i = 0; i < PIXELS_BYTE_COUNT; i += 3) {
    pixelsBuffer[i] = g;
    pixelsBuffer[i + 1] = r;
    pixelsBuffer[i + 2] = b;
  }
  uartSend(pixelsBuffer, PIXELS_BYTE_COUNT);
  delay(2);
}

void wifiConnect() {
  Serial.println("Connecting");
  pixelsSet(0, 0, 255);

  if (WiFi.getMode() != WIFI_STA) WiFi.mode(WIFI_STA);
  if (WiFi.getAutoConnect()) WiFi.setAutoConnect(false);
  WiFi.setAutoReconnect(true);
  WiFi.begin("TheCave", WIFI_PASS);

  int counter = 0;
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print('.');
    pixelsSet(0, 0, 32);
    delay(250);
    pixelsSet(0, 0, 128);
    delay(250);
    counter++;
    if (counter > 30) {
      Serial.println("\nConnect timed out");
      break;
    }
  }

  Serial.print("\nConnect status: ");
  Serial.println(WiFi.status());
  if (WiFi.status() == WL_CONNECTED) {
    Serial.print("Connected successfuly\nIP address: ");
    Serial.println(WiFi.localIP());
  } else {
    pixelsSet(255, 0, 0);
    while (1) yield();
  }
}

void setup() {
#if TOUCH_BUTTON
  pinMode(BUTTON_PIN, INPUT);
#else
  pinMode(BUTTON_PIN, INPUT_PULLUP);
#endif

  uartSetup();

  String chipId = String(ESP.getChipId(), HEX);

  Serial.begin(9600);
  Serial.println("WiFi lamp tester");
  Serial.print("Chip id: ");
  Serial.println(chipId);

  wifiConnect();

  String ssid = "wifilamp-";
  ssid += chipId;
  ArduinoOTA.setHostname(ssid.c_str());

  ArduinoOTA.onStart([]() {
    Serial.println("OTA update start");
    pixelsSet(32, 32, 32);
  });
  ArduinoOTA.onEnd([]() {
    Serial.println("OTA update end");
  });
  ArduinoOTA.onProgress([](unsigned int progress, unsigned int total) {
    Serial.printf("Progress: %u/%u\n", progress, total);
  });
  ArduinoOTA.onError([](ota_error_t error) {
    Serial.printf("Error[%u]: ", error);
    if (error == OTA_AUTH_ERROR) Serial.println("Auth Failed");
    else if (error == OTA_BEGIN_ERROR) Serial.println("Begin Failed");
    else if (error == OTA_CONNECT_ERROR) Serial.println("Connect Failed");
    else if (error == OTA_RECEIVE_ERROR) Serial.println("Receive Failed");
    else if (error == OTA_END_ERROR) Serial.println("End Failed");
  });
  ArduinoOTA.begin();
}

uint8_t buttonReadRaw() {
#if TOUCH_BUTTON
  return digitalRead(BUTTON_PIN);
#else
  return digitalRead(BUTTON_PIN) == LOW;
#endif
}

void loop() {
  if (buttonReadRaw()) {
    pixelsSet(0, 255, 0);
  } else {
    pixelsSet(255, 128, 0);
  }
  ArduinoOTA.handle();
}
