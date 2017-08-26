#include <FS.h>
#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include <WiFiUdp.h>
#include <ArduinoOTA.h>

#define PIXELS_PIN D1
#define PIXELS_COUNT 15
#define PIXELS_BYTE_COUNT (PIXELS_COUNT * 3)
#define PIXELS_TASK_INTERVAL 25UL

#define BUTTON_PIN D5

#define WIFI_CONNECT_DELAY 500
#define WIFI_CONNECT_COUNTER 30

#define WIFI_ENTER_AP_DELAY 20
#define WIFI_ENTER_AP_COUNTER 200

#define WIFI_AP_PREFIX "WiFi-Lamp-"
#define WIFI_AP_PASSWORD "wifilamp"

#define WIFI_CONF_FILE "/conf/wifi.txt"

#define LOGIC_CONF_FILE "/conf/logic.txt"
#define LOGIC_BUTTON_LOCKUP_TIME 1000UL
#define LOGIC_BUTTON_TASK_INTERVAL 100UL

#define FW_VERSION "1"

#define MASTER_RESET_DELAY 20
#define MASTER_RESET_COUNTER 200

#define LOG_ENABLED 1
#define BUTTON_DEBUG 0
