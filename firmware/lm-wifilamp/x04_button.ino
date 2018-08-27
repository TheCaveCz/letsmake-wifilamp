
void buttonSetup() {
  pinMode(BUTTON_PIN, INPUT_PULLUP);
}

uint8_t buttonReadRaw() {
  return digitalRead(BUTTON_PIN) == LOW;
}
