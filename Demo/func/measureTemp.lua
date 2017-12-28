--// Снятие показаний основного термометра
--// Выход: TempInt, TempDec - температура в Цельсиях - целая и дробная части

do
    print("Measure temp...")
    local ow_pin = 4 --5
    ds18b20.setup(ow_pin)
    TempInt = nil
    TempDec = nil
    ds18b20.read(
        function(ind,rom,res,temp,tdec,par)
            print("Temp:", ind,
                string.format("%02X:%02X:%02X:%02X:%02X:%02X:%02X:%02X",
                    string.match(rom,"(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)")),
                res,temp,tdec,par)
            TempInt = temp
            TempDec = tdec
        end,
        {}
    )
end