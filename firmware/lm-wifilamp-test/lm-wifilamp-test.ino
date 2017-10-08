// Enable if you are using touch sensor instead of classic button.
#define TOUCH_BUTTON 0


#define PIXELS_PIN D1
#define PIXELS_COUNT 15
#define PIXELS_BYTE_COUNT (PIXELS_COUNT * 3)

#define BUTTON_PIN D5

#ifdef ESP8266
// ESP8266 show() is external to enforce ICACHE_RAM_ATTR execution
extern "C" void ICACHE_RAM_ATTR espShow(uint8_t pin, uint8_t *pixels, uint32_t numBytes);
#endif

void pixelsSet(uint8_t r, uint8_t g, uint8_t b) {
  uint8_t pixelsBuffer[PIXELS_BYTE_COUNT];
  for (int i = 0; i < PIXELS_BYTE_COUNT; i += 3) {
    pixelsBuffer[i] = g;
    pixelsBuffer[i + 1] = r;
    pixelsBuffer[i + 2] = b;
  }
  espShow(PIXELS_PIN, pixelsBuffer, PIXELS_BYTE_COUNT);
}

void setup() {
#if TOUCH_BUTTON
  pinMode(BUTTON_PIN, INPUT);
#else
  pinMode(BUTTON_PIN, INPUT_PULLUP);
#endif

  pinMode(PIXELS_PIN, OUTPUT);
  digitalWrite(PIXELS_PIN, LOW);


  Serial.begin(9600);
  Serial.println("WiFi lamp tester");
  Serial.print("Chip id: ");
  Serial.println(String(ESP.getChipId(), HEX));

  pixelsSet(0, 0, 0);
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
    pixelsSet(255, 0, 0);
  }
  delay(50);
}
