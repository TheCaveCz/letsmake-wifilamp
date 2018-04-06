
void discoverSetup() {

  SSDP.setDeviceType("upnp:rootdevice");
  SSDP.setSchemaURL("description.xml");
  SSDP.setHTTPPort(80);

  String name = "WiFi lamp (";
  name += chipId;
  name += ")";
  SSDP.setName(name);
  
  SSDP.setSerialNumber(chipId);
  SSDP.setURL("/");
  SSDP.setModelName("The Cave WiFi lamp v1");
  SSDP.setModelNumber("v1");
  SSDP.setModelURL("https://thecave.cz");
  SSDP.setManufacturer("The Cave");
  SSDP.setManufacturerURL("https://thecave.cz");
  SSDP.begin();

  MDNS.addService("http", "tcp", 80);
  MDNS.addService("wifilamp", "tcp", 80);
  MDNS.addServiceTxt("wifilamp", "tcp", "chipid", chipId);
}

