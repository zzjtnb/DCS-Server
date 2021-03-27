--[[
问题：服务器的玩家名字只是"PILOT_"，不能改变
提示：创建服务器个人文件夹文件夹中的脚本：保存的游戏\％DCS_Dedicated_Server％\脚本,并在该文件夹中的文件创建dedicatedServer.lua文本：
--]]
net.set_name('Admin')
local res = net.start_server(serverSettings)
if res ~= 0 then
  log.write('专用服务器', log.DEBUG, '无法以代码启动服务器:', res)
end
