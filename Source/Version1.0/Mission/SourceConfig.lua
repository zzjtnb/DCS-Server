local loadVersion = 'Version1.0'
SourceObj = SourceObj or {}
SourceObj.Config_Dir = lfs.writedir() .. [[SourceData/]]
SourceObj.JSON = loadfile('Scripts/JSON.lua')()
local status, error =
  pcall(
  function()
    dofile(lfs.writedir() .. 'Scripts/Source/' .. loadVersion .. '/Utils/News.lua')
    dofile(lfs.writedir() .. 'Scripts/Source/' .. loadVersion .. '/Database/Aircraft.lua')
    dofile(lfs.writedir() .. 'Scripts/Source/' .. loadVersion .. '/Database/Category.lua')
    dofile(lfs.writedir() .. 'Scripts/Source/' .. loadVersion .. '/Database/Weapon.lua')
    dofile(lfs.writedir() .. 'Scripts/Source/' .. loadVersion .. '/Mission/Common.lua')
    -- dofile(lfs.writedir() .. 'Scripts/Source/' .. loadVersion .. '/Mission/SourceData.lua')
    dofile(lfs.writedir() .. 'Scripts/Source/' .. loadVersion .. '/Mission/SourcePoint.lua')
    dofile(lfs.writedir() .. 'Scripts/Source/' .. loadVersion .. '/Mission/SourceSys.lua')
    dofile(lfs.writedir() .. 'Scripts/Source/' .. loadVersion .. '/Mission/MissionEvent.lua')
  end
)
if (not status) then
  env.error(string.format('资源系统加载失败:%s', error))
else
  env.info('资源系统全部加载完毕')
end
