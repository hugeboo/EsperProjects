--// ��������� ������ adc � ��������� Vdd33
--// �����: Vdd33 - ���������� � ��

do
    if adc.force_init_mode(adc.INIT_VDD33) then
        node.restart()
        return
    end
    Vdd33 = adc.readvdd33(0)
    print("System voltage: "..Vdd33.." mV")
end
