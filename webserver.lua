require('ds18b20')
port = 80


local function handle_request(conn,request)
     -- print("fadesrv:debug: got connection")
   local response = {
     "HTTP/1.1 200 OK\r\n",
     "Content-Type: text/html\r\n",
     "Access-Control-Allow-Origin: *\r\n",
     "Connection: close\r\n",
     "\r\n" }

   local function add(txt)
     table.insert(response,txt)
   end

   local function sender (conn)
     if #response>0 then
        conn:send(table.remove(response,1))
     else
        -- print("fadesrv: closing connection")
        conn:close()
     end
   end

   local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
   if(method == nil)then
       _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
   end
   local _GET = {}
   if (vars ~= nil)then
       for k, v in string.gmatch(vars, "(%w+)=([%w.]+)&*") do
           _GET[k] = v
       end
   end

   --  end preprocessing

   local function send_file(f)
     file.open(f,"r")
     local block = file.read(1024)
     while block do
       add( block )
       block = file.read(1024)
     end
     file.close()
   end

   if path == '/' then
    
        -- CREATE WEBSITE --
    send_file('head.html')
    add("<div class='list-group'>")
    function send_item(a,b)
            add(string.format(
        "<tr><td>%s : <b>%s</b></td></tr>\r\n",
        a,b))
    end
    --send_item("IP",ip)
    send_item("Temperatur", string.format("%3.2f&deg;C",temp))
    send_item("MAC",wifi.sta.getmac())
    send_item("Uptime", string.format("%d seconds",tmr.time()))
    send_item("Heap", string.format("%d bytes",node.heap()))
    
    send_file('end.html')

    elseif path == '/code.js' then
        send_file('code.js')     
    elseif path == '/favicon.ico' then
        send_file('favicon.ico')    
    elseif path == '/color' then
        local r = tonumber(_GET.r or 0)
        local g = tonumber(_GET.g or 0)
        local b = tonumber(_GET.b or 0)
        conn:send("setting LEDS to ("..r..","..g..","..b..")")
        buf = string.char(r,g,b)
        buf = string.rep(buf, 15) 
        ws2812.writergb(ledpin,buf)
    elseif path == '/restart' then
        conn:send("bye")
        node.restart()   
    else
    debug_text = path
    conn:send("unknown path " .. path .. "\r\n")
    end

        -- print("starting sender")
   conn:on("sent", sender)
   sender(conn) 
end

srv=net.createServer(net.TCP,30)
srv:listen(port,function(conn)
    conn:on("receive", handle_request)
end)

