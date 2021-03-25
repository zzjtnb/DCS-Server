-- ServerData for DCS World https://github.com/szporwolik/ServerData -> DCS Hook component

ServerData.RefreshStatus = ServerDataConfig.RefreshStatus
ServerData.MissionStartNoDeathWindow = ServerDataConfig.MissionStartNoDeathWindow
ServerData.DebugMode = ServerDataConfig.DebugMode
ServerData.MOTD_L1 = ServerDataConfig.MOTD_L1
ServerData.MOTD_L2 = ServerDataConfig.MOTD_L2
ServerData.ConnectionError = ServerDataConfig.ConnectionError_L1
ServerData.BroadcastServerDataErrors = ServerDataConfig.BroadcastServerDataErrors

-- Variable init
ServerData.Version = ServerDataConfig.Version
ServerData.PlayersTableCache = {}
ServerData.MissionHash = ""

ServerData.lastSentStatus = 0
ServerData.lastSentMission = 0
ServerData.lastConnectionError = 0
ServerData.lastFrameStart = 0
ServerData.lastTimer = 0
ServerData.lastFrameTime = 0

ServerData.ReconnectTimeout = 30
ServerData.RefreshKeepAlive = 3

if DCS.isServer() then
  ServerData.MissionHash = ServerData.GenerateMissionHash() -- Generate initial missionhash
  --Set user callbacs,map DCS event handlers with functions defined above
  --设置用户callbacs,使用上面定义的功能映射DCS事件处理程序
  DCS.setUserCallbacks(ServerData.callbacks)
  Debugger.AddLog("Loaded - ServerData for DCS World - version: " .. ServerData.Version, 0) -- Display
end
