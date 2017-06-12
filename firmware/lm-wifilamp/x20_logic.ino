
struct LogicConfig {
  String adminPass;
  uint8_t colorR;
  uint8_t colorG;
  uint8_t colorB;
  bool on;
  uint16_t defaultTurnOnSpeed;
} logicConfig;

uint8_t logicColorR;
uint8_t logicColorG;
uint8_t logicColorB;
bool logicOn;

uint32_t logicButtonTaskTime;
uint32_t logicButtonTaskInterval;



uint8_t logicButtonCounter;

void logicSetup() {
  logicButtonCounter = 0;
  logicReadConfig();

  logicColorR = logicConfig.colorR;
  logicColorG = logicConfig.colorG;
  logicColorB = logicConfig.colorB;
  logicOn = logicConfig.on;
  logicButtonTaskTime = 0;
  logicButtonTaskInterval = LOGIC_BUTTON_TASK_INTERVAL;
}

void logicButtonTask() {
  uint32_t now = millis();
  if (now - logicButtonTaskTime < logicButtonTaskInterval) return;
  logicButtonTaskTime = now;
  logicButtonTaskInterval = LOGIC_BUTTON_TASK_INTERVAL;


  if (logicButtonCounter == 255) {
    logicButtonCounter = buttonReadRaw() ? 255 : 0;
    if (logicButtonCounter == 0) {
      logicButtonTaskInterval = LOGIC_BUTTON_LOCKUP_TIME;
    }
  } else {
    logicButtonCounter = buttonReadRaw() ? logicButtonCounter + 1 : 0;
    if (logicButtonCounter >= 3) {
      logInfo("Button trigger");
      logicSetState(!logicOn, logicConfig.defaultTurnOnSpeed);
      logicButtonCounter = 255;
    }
  }
}

bool logicSetState(const bool on, const uint16_t time) {
  if (logicOn == on) return false;

  logInfo("Set state");
  logicOn = on;
  logicUpdatePixels(time);
  return true;
}

void logicSetColor(const uint8_t r, const uint8_t g, const uint8_t b, const uint16_t time) {
  if (logicColorR == r && logicColorG == g && logicColorB == b) return;

  logInfo("Set color");
  logicColorR = r;
  logicColorG = g;
  logicColorB = b;
  if (logicOn) {
    logicUpdatePixels(time);
  }
}

void logicUpdatePixels(const uint16_t time) {
  if (logicOn) {
    pixelsAnimate(logicColorR, logicColorG, logicColorB, time);
  } else {
    pixelsAnimate(0, 0, 0, time);
  }
}

void logicResetConfig() {
  logicConfig.adminPass = "wifilamp";
  logicColorR = logicConfig.colorR = 255;
  logicColorG = logicConfig.colorG = 255;
  logicColorB = logicConfig.colorB = 255;
  logicOn = logicConfig.on = true;
  logicConfig.defaultTurnOnSpeed = 1000;
  logicWriteConfig();
}

void logicReadConfig() {
  logInfo("Reading logic config");
  File cfg = SPIFFS.open(LOGIC_CONF_FILE, "r");
  if (cfg) {
    logicConfig.adminPass = cfg.readStringUntil('\n');
    logicConfig.colorR = cfg.readStringUntil('\n').toInt();
    logicConfig.colorG = cfg.readStringUntil('\n').toInt();
    logicConfig.colorB = cfg.readStringUntil('\n').toInt();
    logicConfig.on = cfg.readStringUntil('\n').toInt() ? true : false;
    logicConfig.defaultTurnOnSpeed = cfg.readStringUntil('\n').toInt();
    cfg.close();
  } else {
    logInfo("Unable to open logic config");
    logicResetConfig();
  }

  logValue(" colorR: ", logicConfig.colorR);
  logValue(" colorG: ", logicConfig.colorG);
  logValue(" colorB: ", logicConfig.colorB);
  logValue(" on: ", logicConfig.on);
  logValue(" onSpeed: ", logicConfig.defaultTurnOnSpeed);
}

bool logicSetAdminPass(const String& pass) {
  logInfo("Changing admin pass");
  logicConfig.adminPass = pass;
  return logicWriteConfig();
}

bool logicSetDefaults(uint8_t r, uint8_t g, uint8_t b, bool on) {
  logHeader();
  logRaw("Change defaults R:");
  logRaw(r);
  logRaw(", G:");
  logRaw(g);
  logRaw(", B:");
  logRaw(b);
  logRaw(", on:");
  logRaw(on);
  logLine();

  if (r != 0 || g != 0 || b != 0) {
    logicConfig.colorR = r;
    logicConfig.colorG = g;
    logicConfig.colorB = b;
  }
  logicConfig.on = on;
  return logicWriteConfig();
}

bool logicWriteConfig() {
  logInfo("Writing logic config");
  File cfg = SPIFFS.open(LOGIC_CONF_FILE, "w");
  if (!cfg) {
    logInfo("Unable to create logic config");
    return false;
  }

  cfg.print(logicConfig.adminPass);
  cfg.write('\n');
  cfg.print(logicConfig.colorR);
  cfg.write('\n');
  cfg.print(logicConfig.colorG);
  cfg.write('\n');
  cfg.print(logicConfig.colorB);
  cfg.write('\n');
  cfg.write(logicConfig.on ? '1' : '0');
  cfg.write('\n');
  cfg.print(logicConfig.defaultTurnOnSpeed);
  cfg.write('\n');

  cfg.close();
  return true;
}


