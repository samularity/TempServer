tmr.alarm(0, 5000, tmr.ALARM_SINGLE, function() 
    print("Start running")
    require('ds18b20')
    ds18b20.setup(1)
    ledpin = 4
    default_buf= string.rep(string.char(25,25,25), 9)

    ws2812.writergb(ledpin, default_buf) -- turn three WS2812Bs to red, green, and blue respectively

    
    dofile("AP_setup.lc")
    dofile("display.lc")
    dofile("webserver.lc")
end) 
