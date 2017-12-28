--// Синхронизация времени с SNTP сервером
--// выход: LastSyncTime - время последней синхронизации в секундах, nil - в процессе или ошибка синхронизации
--//        TimeSyncInProcess - синхронизация в процессе

do
    local tsec = rtctime.get()
    if (LastSyncTime == nil or (tsec<LastSyncTime) or (tsec-LastSyncTime)>3600*24) then
        LastSyncTime = nil
        TimeSyncInProcess = 1
        print("SNTP sync...")
        sntp.sync({"195.91.239.8","ntp1.stratum2.ru","ntp5.stratum2.ru"},
            function(sec, usec, server, info)
                print("SNTP sync success: "..sec.."s "..usec.."u "..server)
                LastSyncTime = sec
                TimeSyncInProcess = nil
            end,
            function()
                print("SNTP sync failed!")
                LastSyncTime = nil
                TimeSyncInProcess = nil
            end
        )
    else
        TimeSyncInProcess = nil
        print("Time already sync")
    end
end