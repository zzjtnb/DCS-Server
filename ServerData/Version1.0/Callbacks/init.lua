local loadVersion = "Version1.0"
net.log("INFO: 服务器数据Callbaks->正在加载...")
local status, error =
  pcall(
  function()
    ----------------------------------------Event事件处理开始-------------------------------------
    dofile(lfs.writedir() .. "Scripts/ServerData/" .. loadVersion .. "/Callbacks/Event/connect.lua")
    dofile(lfs.writedir() .. "Scripts/ServerData/" .. loadVersion .. "/Callbacks/Event/disconnect.lua")
    dofile(lfs.writedir() .. "Scripts/ServerData/" .. loadVersion .. "/Callbacks/Event/change_slot.lua")
    dofile(lfs.writedir() .. "Scripts/ServerData/" .. loadVersion .. "/Callbacks/Event/takeoff.lua")
    dofile(lfs.writedir() .. "Scripts/ServerData/" .. loadVersion .. "/Callbacks/Event/self_kill.lua")
    dofile(lfs.writedir() .. "Scripts/ServerData/" .. loadVersion .. "/Callbacks/Event/kill.lua")
    dofile(lfs.writedir() .. "Scripts/ServerData/" .. loadVersion .. "/Callbacks/Event/pilot_death.lua")
    dofile(lfs.writedir() .. "Scripts/ServerData/" .. loadVersion .. "/Callbacks/Event/eject.lua")
    dofile(lfs.writedir() .. "Scripts/ServerData/" .. loadVersion .. "/Callbacks/Event/crash.lua")
    dofile(lfs.writedir() .. "Scripts/ServerData/" .. loadVersion .. "/Callbacks/Event/landing.lua")
    ----------------------------------------Event事件处理结束-------------------------------------
    dofile(lfs.writedir() .. "Scripts/ServerData/" .. loadVersion .. "/Callbacks/serverDataCall.lua")
  end
)
if (not status) then
  net.log(string.format("ERROR: 服务器数据Callbaks加载失败:%s", error))
else
  net.log("INFO: 服务器数据Callbaks->已全部加载")
end
