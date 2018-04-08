
void buttonSetup() {
#if TOUCH_BUTTON
  pinMode(BUTTON_PIN, INPUT);
#else
  pinMode(BUTTON_PIN, INPUT_PULLUP);
#endif
}

uint8_t buttonReadRaw() {
#if TOUCH_BUTTON
  return digitalRead(BUTTON_PIN);
#else
  return digitalRead(BUTTON_PIN) == LOW;
#endif
}

