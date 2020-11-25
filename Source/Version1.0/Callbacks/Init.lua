local loadVersion = "Version1.0"
SourceCall = SourceCall or {}
SourceCall.Config_Dir = lfs.writedir() .. [[SourceData/]]
SourceCall.JSON = require("JSON")
local status, error =
  pcall(
  function()
    dofile(lfs.writedir() .. "Scripts/Source/" .. loadVersion .. "/Utils/Character.lua")
    dofile(lfs.writedir() .. "Scripts/Source/" .. loadVersion .. "/Utils/News.lua")
    dofile(lfs.writedir() .. "Scripts/Source/" .. loadVersion .. "/Callbacks/Chatcmd.lua")
    dofile(lfs.writedir() .. "Scripts/Source/" .. loadVersion .. "/Callbacks/AdminList.lua")
    dofile(lfs.writedir() .. "Scripts/Source/" .. loadVersion .. "/Callbacks/SourceCall.lua")
  end
)
if (not status) then
  net.log(string.format("资源系统Callbaks加载失败:%s", error))
else
  net.log("资源系统Callbaks全部加载完毕")
end
