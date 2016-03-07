# TempServer
Modified colour picker from https://github.com/makefu/SmartestHome

  - `init.lua` : startup script for esp
  - `AP_setup.lua` : setup the wifi connection
  - `display.lua` : updates the display
  - `ds18b20.lua` : read the temperature
  - `webserver.lua` : do the html handling
  - `head.html` : first part of the website
  - `end.html` : last part of the website
  - `code.js` : js for colourpicker
  - `favicon.ico` : icon for taskbar
  - `testtemplate.html` : local complete website for testing


<b>Connections to NodeMCU-Module</b>

- Display: ssd1306 - 128x64 
    - VCC <-> 3,3V
    - GND <-> GND
    - SCL <-> D6
    - SDA <-> D5
- LED (WS2812 Stripe)
    - VCC <-> 5V
    - GND <-> GND
    - DIN <-> D4
- Temperatur Sensor DS18B20
    - VCC(Pin3) <-> 3,3V
    - GND(Pin1) <-> GND
    - DQ(Pin2) <-> D1
    - DQ(Pin2) <-4k7-> 3,3V
