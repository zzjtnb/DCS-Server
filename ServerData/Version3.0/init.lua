local loadVersion = 'Version3.0'
net.log('INFO: 服务器数据Callbaks->正在加载...')
local status, error =
  pcall(
  function()
    ----------------------------------------Common-------------------------------------
    dofile(lfs.writedir() .. 'Scripts/ServerData/' .. loadVersion .. '/Common/Config.lua')
    dofile(lfs.writedir() .. 'Scripts/ServerData/' .. loadVersion .. '/Common/common.lua')
    dofile(lfs.writedir() .. 'Scripts/ServerData/' .. loadVersion .. '/Common/Logs.lua')
    ----------------------------------------Event事件-------------------------------------
    dofile(lfs.writedir() .. 'Scripts/ServerData/' .. loadVersion .. '/Callbacks/Event/onMission.lua')
    dofile(lfs.writedir() .. 'Scripts/ServerData/' .. loadVersion .. '/Callbacks/Event/onGame.lua')
    dofile(lfs.writedir() .. 'Scripts/ServerData/' .. loadVersion .. '/Callbacks/Event/onPlayer.lua')
    dofile(lfs.writedir() .. 'Scripts/ServerData/' .. loadVersion .. '/Callbacks/Event/onSimulation.lua')
    ----------------------------------------Callbacks-------------------------------------
    dofile(lfs.writedir() .. 'Scripts/ServerData/' .. loadVersion .. '/Callbacks/serverDataCall.lua')
  end
)
if (not status) then
  net.log(string.format('ERROR: 服务器数据Callbaks加载失败:%s', error))
else
  net.log('INFO: 服务器数据Callbaks->已全部加载')
end
