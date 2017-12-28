print("\n--- Esper Nodes v1 ---")
print("28.12.17 Simple thermo sensor\n")

_, bootreason = node.bootreason()
print("Boot reason: "..bootreason)

if bootreason == 0 then
    print("Power on. Sleep 5 sec...")
    tmr.alarm(0, 5000, 1, function() 
        tmr.unregister(0)
        print("Dofile main.lua...")
        tmr.softwd(20)
        dofile("main.lua")
    end) 
else
    print("Dofile main.lua...")
    tmr.softwd(20)
    dofile("main.lua")
end
