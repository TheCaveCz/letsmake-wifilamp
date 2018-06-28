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


// Enable button debugging - one LED is red when button is pressed.
#define BUTTON_DEBUG 0

// Firmware updates over-the-air will require admin password.
//#define OTA_PASSWORD "mySecretPassword"

// Enable HTTP OPTIONS method response handler - useful for remote webpage debugging
#define OPTIONS_ENABLED 1

// Enable if you are using touch sensor instead of classic button.
#define TOUCH_BUTTON 0

// Serial port logging
#define LOG_ENABLED 1

#define API_PASSWORD "wifilamp"



#define PIXELS_COUNT 17
#define PIXELS_BYTE_COUNT (PIXELS_COUNT * 3)
#define PIXELS_TASK_INTERVAL 25UL

#define BUTTON_PIN D2

#define BLYNK_DEFAULT_TOKEN ""

#define BLYNK_RGB_PIN V0
#define BLYNK_BUTTON_PIN V1
#define BLYNK_RGB_R_PIN V2
#define BLYNK_RGB_G_PIN V3
#define BLYNK_RGB_B_PIN V4
#define BLYNK_SPEED_PIN V5

#define HOSTNAME_PREFIX "wifilamp-"

#if TOUCH_BUTTON
#define LOGIC_BUTTON_TASK_INTERVAL 50UL
#define LOGIC_BUTTON_LOCKUP_TIME 1000UL
#else
#define LOGIC_BUTTON_TASK_INTERVAL 10UL
#define LOGIC_BUTTON_LOCKUP_TIME 500UL
#endif

#define FW_VERSION "3"

String chipId = String(ESP.getChipId(),HEX);

