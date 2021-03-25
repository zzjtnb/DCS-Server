net.log("INFO: serverData-->正在加载...")
local loadVersion = "Version1.0"
local status, error =
  pcall(
  function()
    dofile(lfs.writedir() .. "Scripts/ServerData/" .. loadVersion .. "/Common/Config.lua")
    dofile(lfs.writedir() .. "Scripts/ServerData/" .. loadVersion .. "/Common/Logs.lua")
    dofile(lfs.writedir() .. "Scripts/ServerData/" .. loadVersion .. "/common.lua")
    dofile(lfs.writedir() .. "Scripts/ServerData/" .. loadVersion .. "/Callbacks/init.lua")
  end
)
if (not status) then
  net.log(string.format("ERROR: serverData加载失败:%s", error))
else
  net.log("INFO: serverData-->全部加载完毕...")
end
