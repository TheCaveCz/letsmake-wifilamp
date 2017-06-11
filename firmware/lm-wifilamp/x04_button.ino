
void buttonSetup() {
  pinMode(BUTTON_PIN, INPUT);
}

uint8_t buttonReadRaw() {
  return digitalRead(BUTTON_PIN);
}

