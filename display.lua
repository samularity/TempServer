require('ds18b20')

function init_i2c_display()
    -- SDA and SCL can be assigned freely to available GPIOs
    local sda = 5 -- GPIO14
    local scl = 6 -- GPIO12
    local sla = 0x3c
    i2c.setup(0, sda, scl, i2c.SLOW)
    disp = u8g.ssd1306_128x64_i2c(sla)
    disp:setFont(u8g.font_6x10)
    disp:setFontRefHeightExtendedText()
    disp:setDefaultForegroundColor()
    disp:setFontPosTop()
end

local function info_display()

    function draw()
        local sta_ip,_,_=wifi.sta.getip()
        if not sta_ip then sta_ip = "NO IP" end

        local ap_ip,_,_=wifi.ap.getip()
        if not ap_ip then ap_ip = "NO IP" end
    
        disp:drawStr(0,0,"smarthome")
        disp:drawStr(0,10, string.format("staIP:%15s",sta_ip))
        disp:drawStr(0,20, string.format("apIP:%15s",ap_ip))
        disp:drawStr(0,40,  string.format("up: %d Sek",tmr.time()))
        disp:drawStr(0,50,  string.format("mem: %d byte", node.heap()))
        disp:drawStr(0,60,  "dbg: " .. debug_text)
    end

    
    disp:setFont(u8g.font_6x10)
    disp:firstPage()
    repeat
        draw()
    until disp:nextPage() == false
end

local function temp_display()
    function draw()
        disp:drawStr(0,40,  string.format("%3.2f %sC",temp,string.char(176)))
    end
    
    disp:firstPage()
    disp:setFont(u8g.font_gdr20)
    repeat
        draw()
    until disp:nextPage() == false
end

init_i2c_display()
debug_text = ""
show_temp= false
tmr.register(5, 2000, tmr.ALARM_AUTO, 
        function() 
        
        if show_temp then 
            show_temp = false 
            info_display()
        else
            temp=ds18b20.read()
            if not temp then temp = -255 end
            temp_display()
            show_temp = true 
        end
 end
)
tmr.start(5)
