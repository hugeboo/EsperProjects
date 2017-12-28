--// Установка режима adc и измерение Vdd33
--// Выход: Vdd33 - напряжение в мВ

do
    if adc.force_init_mode(adc.INIT_VDD33) then
        node.restart()
        return
    end
    Vdd33 = adc.readvdd33(0)
    print("System voltage: "..Vdd33.." mV")
end
