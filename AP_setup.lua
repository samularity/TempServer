ip_cfg =
  {
   ip="192.168.0.1",
   netmask="255.255.255.0",
   gateway="192.168.0.1"
  }
  
wifi.setphymode(wifi.PHYMODE_G)  
wifi.setmode(wifi.STATIONAP) --setup in dual mode
wifi.sta.config("ssidgoeshere", "enteryourpwhere", 1)


wifi.ap.config({ssid='temperatur'})
wifi.ap.setip(ip_cfg)
wifi.ap.dhcp.start()  -- important!