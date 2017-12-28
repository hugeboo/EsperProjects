--// MQTT ���������� ��������� ������� (����� ���������� wifi-�����������)
--// ����: MqttClient - ������ MQTT
--//       MqttMac - ������������� ���������� (6 ����. hex-���� MAC)
--//       Vdd33 - ���������� �������
--//       LastSyncTime - ����� ��������� ������������� �������

do
    --if LastSyncTime then
    --    local tm = rtctime.epoch2cal(rtctime.get())
    --    local ts = string.format("%04d/%02d/%02d %02d:%02d:%02d", 
    --        tm["year"], tm["mon"], tm["day"], 
    --        tm["hour"], tm["min"], tm["sec"])
    --    MqttClient:publish(MqttMac.."/state/node/time", ts, 0, 1)
    --else
    --    MqttClient:publish(MqttMac.."/state/node/time", "ERR", 0, 1)
    --end

    if Vdd33 then
        MqttClient:publish(MqttMac.."/state/node/vdd33", Vdd33, 0, 1)
    else
        MqttClient:publish(MqttMac.."/state/node/vdd33", "ERR", 0, 1)
    end

    local rssi = wifi.sta.getrssi()
    if rssi then
        MqttClient:publish(MqttMac.."/state/node/wifi/rssi", rssi, 0, 1)
    else
        MqttClient:publish(MqttMac.."/state/node/wifi/rssi", "ERR", 0, 1)
    end
end
