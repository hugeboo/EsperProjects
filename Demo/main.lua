function publishData(onComplete)
    publishTable({
        {topic="/state/node/vdd33", data=Vdd33},
        {topic="/state/node/wifi/rssi", data=wifi.sta.getrssi()},
        --//{topic="/state/node/wifi/ssid", data=wifi.sta.getconfig(true).ssid},
        --//{topic="/state/node/wifi/ip", data=wifi.sta.getip()},
        {topic="/state/temp", data=TempInt.."."..TempDec}
        },
        function()
            if onComplete then onComplete() end
        end)
end

function publishTable(table, onComplete)
    local mac = wifi.sta.getmac()
    mac = string.sub(mac,-8,-7)..string.sub(mac,-5,-4)..string.sub(mac,-2,-1);
    local mc = mqtt.Client(mac, 120, "sreuxfkx", "UCImiG1bEvxX")
    mc:connect("m14.cloudmqtt.com", 13715, 0, 
        function(client)
            print("MQTT connected ("..mac..")")
            publishTableRecursive(client, mac, table, 1,
                function(c)
                    client:close()
                    print("MQTT closed")
                    if onComplete then onComplete() end
                end)
        end,
        function(client, reason)
            print("MQTT failed reason: "..reason)
        end)
end

function publishTableRecursive(client, mac, table, index, onComplete)
    local it = table[index]
    local d = nil
    if it.data then d = tostring(it.data) else f = "ERR" end
    client:publish(mac .. it.topic, d, 0, 1,
        function(c)
            print(it.topic .. " => " .. d)
            if index < #table then
                publishTableRecursive(client, mac, table, index+1, onComplete)
            else
                if onComplete then onComplete(c) end
            end
        end)
end

wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, 

    function(T)
        print("\n\tSTA - GOT IP".."\n\tStation IP: "..T.IP..
              "\n\tSubnet mask: "..T.netmask..
              "\n\tGateway IP: "..T.gateway)
        wifi.eventmon.unregister(wifi.eventmon.STA_GOT_IP)

        dofile("node/measureVdd33.lua")

        --dofile("node/syncTime.lua")
        --tmr.alarm(0, 1000, 1, function() 
        --   if TimeSyncInProcess == nil
        --    then
        --        tmr.unregister(0)
        --        dofile("func/measureTemp.lua")
        --    end
        --end) 

        dofile("func/measureTemp.lua")
        tmr.alarm(1, 1000, 1, function() 
            if TempInt and TempDec then
                tmr.unregister(1)
                print("Publish data...")
                publishData(function()
                    print("Bye!")
                    rtctime.dsleep(1800*1000000)
                end)
            end
        end) 
    end
)

wifi.setmode(wifi.STATION, false)
local cfg={}
cfg.ssid="ssv-redmi" --"ZyXEL_SOS"
cfg.pwd="65046504" --"valentinich123"
wifi.sta.config(cfg)
cfg = nil
collectgarbage()
