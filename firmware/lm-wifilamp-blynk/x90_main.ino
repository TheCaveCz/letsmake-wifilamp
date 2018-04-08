

BLYNK_CONNECTED() {
  Blynk.syncAll();
}

BLYNK_WRITE(BLYNK_RGB_PIN) {
  logicSetColor(param[0].asInt(), param[1].asInt(), param[2].asInt());
}

BLYNK_WRITE(BLYNK_RGB_R_PIN) {
  logicSetColor(param.asInt(), logicColorG, logicColorB);
}

BLYNK_WRITE(BLYNK_RGB_G_PIN) {
  logicSetColor(logicColorR, param.asInt(), logicColorB);
}

BLYNK_WRITE(BLYNK_RGB_B_PIN) {
  logicSetColor(logicColorR, logicColorG, param.asInt());
}

BLYNK_WRITE(BLYNK_BUTTON_PIN) {
  logicSetState(param.asInt());
}

BLYNK_WRITE(BLYNK_SPEED_PIN) {
  logicTransitionTime = param.asInt() * 100;
}


void setup() {
  Serial.begin(9600);

  logInfo("Starting");
  logValue("Chip id: ", chipId);

  buttonSetup();
  pixelsSetup();
  logicSetup();

  wifiConnect();
  otaSetup();

  pixelsSet(0, 32, 0);
  logInfo("Connecting to Blynk");
  Blynk.config(BLYNK_TOKEN);
  while (Blynk.connect() != true) { }
  
  logInfo("Ready to go!");
}

void loop() {
  Blynk.run();

  ArduinoOTA.handle();
  pixelsTask();
  logicButtonTask();
}

