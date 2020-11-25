local loadVersion = "Version2.0"
SourceObj = SourceObj or {}
SourceObj.JSON = require("JSON")
local status, error =
  pcall(
  function()
    dofile(lfs.writedir() .. "Scripts/Source/" .. loadVersion .. "/Utils/SourceData.lua")
    dofile(lfs.writedir() .. "Scripts/Source/" .. loadVersion .. "/Utils/Common.lua")
    dofile(lfs.writedir() .. "Scripts/Source/" .. loadVersion .. "/SourceEvent.lua")
  end
)
if (not status) then
  net.log(string.format("资源系统加载失败:%s", error))
else
  net.log("资源系统全部加载完毕")
end
