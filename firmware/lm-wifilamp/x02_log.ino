
class LogBuffer : public Print {
  public:
    LogBuffer(uint16_t capacity) {
      _buffer = (uint8_t*)malloc(capacity);
      _pos = 0;
      _length = 0;
      if (_buffer) {
        _capacity = capacity;
      } else {
        _capacity = 0;
      }
    }

    ~LogBuffer() {
      free(_buffer);
      _buffer = NULL;
      _capacity = 0;
    }

    inline uint16_t getPos() {
      return _pos;
    }
    inline uint16_t getLength() {
      return _length;
    }
    inline uint8_t* getBuffer() {
      return _buffer;
    }

    virtual size_t write(uint8_t data) {
      if (!_capacity) return 0;

      _buffer[_pos] = data;
      _pos++;
      if (_pos >= _capacity) {
        _pos = 0;
      }
      if (_length < _capacity) {
        _length++;
      }

      return 1;
    }

    void reset() {
      _pos = 0;
      _length = 0;
    }

    void dumpTo(WiFiClient client) {
      if (_length >= _capacity) {
        client.write((const uint8_t*)(_buffer + _pos), _length - _pos);
      }
      if (_length) {
        client.write((const uint8_t*)_buffer, _pos);
      }
    }

    void dumpTo(ESP8266WebServer * server) {
      server->setContentLength(_length);
      server->send(200, "text/plain");
      dumpTo(server->client());
    }


  private:
    uint8_t * _buffer;
    uint16_t _capacity;
    uint16_t _pos;
    uint16_t _length;
};


#if LOG_ENABLED
LogBuffer logBuffer(4096);
#define logRaw(msg) logBuffer.print(msg);Serial.print(msg);
#else
#define logRaw(msg)
#endif

#define logLine() logRaw('\n')
#define logHeader() logRaw(millis());logRaw(" | ");
#define logInfo(msg) logHeader();logRaw(F(msg));logLine()
#define logValue(msg,val) logHeader();logRaw(F(msg));logRaw(val);logLine()

