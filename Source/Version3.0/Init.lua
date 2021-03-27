net.log('INFO: 资源系统Callbaks->正在加载...')
local loadVersion = 'Version3.0'
local status, error =
  pcall(
  function()
    dofile(lfs.writedir() .. 'Scripts/Source/' .. loadVersion .. '/Common/Character.lua')
    dofile(lfs.writedir() .. 'Scripts/Source/' .. loadVersion .. '/Callbacks/Utils/FileData.lua')
    dofile(lfs.writedir() .. 'Scripts/Source/' .. loadVersion .. '/Callbacks/Utils/Common.lua')
    dofile(lfs.writedir() .. 'Scripts/Source/' .. loadVersion .. '/Callbacks/Chats/ChatFile.lua')
    dofile(lfs.writedir() .. 'Scripts/Source/' .. loadVersion .. '/Callbacks/Chats/AdminCmd.lua')
    dofile(lfs.writedir() .. 'Scripts/Source/' .. loadVersion .. '/Callbacks/Chats/PlayerCmd.lua')
    dofile(lfs.writedir() .. 'Scripts/Source/' .. loadVersion .. '/Callbacks/Config.lua')
    dofile(lfs.writedir() .. 'Scripts/Source/' .. loadVersion .. '/Callbacks/AdminList.lua')
    ----------------------------------------Event事件处理开始-------------------------------------
    dofile(lfs.writedir() .. 'Scripts/Source/' .. loadVersion .. '/Callbacks/Event/change_slot.lua')
    dofile(lfs.writedir() .. 'Scripts/Source/' .. loadVersion .. '/Callbacks/Event/friendly_fire.lua')
    ----------------------------------------Event事件处理结束-------------------------------------
    dofile(lfs.writedir() .. 'Scripts/Source/' .. loadVersion .. '/Callbacks/SourceCall.lua')
  end
)
if (not status) then
  net.log(string.format('ERROR: 资源系统Callbaks加载失败:%s', error))
else
  net.log('INFO: 资源系统Callbaks->全部加载完毕...')
end
