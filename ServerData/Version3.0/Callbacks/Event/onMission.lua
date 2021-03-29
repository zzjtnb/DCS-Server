ServerData.callbacks.onMissionLoadEnd = function()
  -- Simulation was started
  ServerData.MissionHash = ServerData.GenerateMissionHash()
  ServerData.LogEvent('onMissionLoadEnd', 'Mission ' .. ServerData.MissionHash .. ' started', nil, nil)
  ServerData.StatData = {}
  ServerData.StatDataLastType = {}
  ServerData.PlayersTableCache = {}
  ServerData.SlotsData = {}
  ServerData.MissionData = {}
  -- reset so mission information will be send
  -- 重置,以便发送任务信息
  ServerData.lastSentMission = 0
end
