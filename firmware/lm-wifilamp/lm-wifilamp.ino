/*
 * WifiLamp firmware for Blynk app
 */
#define BLYNK_PRINT Serial

#include <ESP8266WiFi.h>
#include <BlynkSimpleEsp8266.h>
#include <ESP8266mDNS.h>
#include <ArduinoOTA.h>
#include <WiFiManager.h>
#include <Ticker.h>
#include <EEPROM.h>
#include "ws2812.h"


// Firmware updates over-the-air will require admin password.
//#define OTA_PASSWORD "mySecretPassword"

// Enable HTTP OPTIONS method response handler - useful for remote webpage debugging
#define OPTIONS_ENABLED 0

// Serial port logging
#define LOG_ENABLED 1

// Password for http api, comment out to disable
#define API_PASSWORD "wifilamp"



#define PIXELS_COUNT 15
#define PIXELS_BYTE_COUNT (PIXELS_COUNT * 3)
#define PIXELS_TASK_INTERVAL 25UL

#define BUTTON_PIN D2

#define BLYNK_RGB_PIN V0
#define BLYNK_BUTTON_PIN V1
#define BLYNK_RGB_R_PIN V2
#define BLYNK_RGB_G_PIN V3
#define BLYNK_RGB_B_PIN V4
#define BLYNK_SPEED_PIN V5

#define HOSTNAME_PREFIX "wifilamp-"

#define LOGIC_BUTTON_TASK_INTERVAL 20UL
#define LOGIC_BUTTON_LOCKUP_TIME 500UL

#define FW_VERSION "4"

String chipId = String(ESP.getChipId(),HEX);
