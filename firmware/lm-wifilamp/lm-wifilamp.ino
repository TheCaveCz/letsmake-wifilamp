#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <TaskScheduler.h>
#include <ESP8266mDNS.h>
#include <WiFiUdp.h>
#include <ArduinoOTA.h>

#define PIXELS_PIN D1
#define PIXELS_COUNT 15
#define PIXELS_BYTE_COUNT (PIXELS_COUNT * 3)


#define CFG_SSID ""
#define CFG_PWD ""


#define CFG_HOSTNAME "lm-wifilamp"


Scheduler scheduler;


