--// MQTT публикация параметров wifi-подключения
--// Вход: MqttClient - клиент MQTT
--//       MqttMac - идентификатор устройства (6 посл. hex-цифр MAC)

do
    local sta_config=wifi.sta.getconfig(true)
    if sta_config and sta_config.ssid then
        MqttClient:publish(MqttMac.."/state/node/wifi/ssid", sta_config.ssid, 0, 1)
    else
        MqttClient:publish(MqttMac.."/state/node/wifi/ssid", "ERR", 0, 1)
    end

    local ip = wifi.sta.getip()
    if ip then
        MqttClient:publish(MqttMac.."/state/node/wifi/ip", ip, 0, 1)
    else
        MqttClient:publish(MqttMac.."/state/node/wifi/ip", "ERR", 0, 1)
    end
end
