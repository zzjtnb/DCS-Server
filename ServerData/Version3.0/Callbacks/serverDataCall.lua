-- ServerData for DCS World https://github.com/szporwolik/ServerData -> DCS Hook component

if DCS.isServer() then
  ServerData.MissionHash = ServerData.GenerateMissionHash() -- Generate initial missionhash
  --Set user callbacs,map DCS event handlers with functions defined above
  --设置用户callbacs,使用上面定义的功能映射DCS事件处理程序
  DCS.setUserCallbacks(ServerData.callbacks)
  Logger.AddLog('Loaded - ServerData for DCS World - version: ' .. ServerData.Version, 0) -- Display
end
