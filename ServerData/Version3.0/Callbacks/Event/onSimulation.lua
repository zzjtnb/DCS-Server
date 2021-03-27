ServerData.callbacks.onSimulationFrame = function()
  -- Repeat for each simulator frame
  -- 重复每个模拟器帧
  local _now = DCS.getRealTime()
  ServerData.lastFrameStart = _now
  -- Send mission update - First run or update required (set on connection errors)
  -- 发送任务更新-首次运行或需要更新（针对连接错误进行设置）
  if ServerData.lastSentMission == 0 and _now > 0 then
    ServerData.lastSentMission = _now
    ServerData.UpdateMission()
    ServerData.UpdateSlots()
    ServerData.UpdateStatus()
  end
  -- Send status update - update required
  -- 发送状态更新-需要更新
  if _now > ServerData.lastSentStatus + ServerData.RefreshStatus then
    ServerData.lastSentStatus = _now
    ServerData.UpdateStatus()
  end

  -- Calucalate time on slot per each of players
  -- 计算每个玩家在插槽上的时间
  if _now > ServerData.lastTimer + 60 then
    ServerData.lastTimer = _now
    local _all_players = net.get_player_list()
    for PlayerIDIndex, _playerID in ipairs(_all_players) do
      if _playerID ~= 1 then
        ServerData.LogStatsCount(_playerID, 'timer', true)
      end
    end
  end
  -- Calculate approx. frame time
  ServerData.lastFrameTime = DCS.getRealTime() - _now
end
ServerData.callbacks.onSimulationStop = function()
  -- 游戏界面已停止
  -- Simulation was stopped
  ServerData.LogEvent('SimStop', 'Mission ' .. ServerData.MissionHash .. ' finished', nil, nil)
  ServerData.LogAllStats()
  ServerData.MissionHash = ServerData.GenerateMissionHash()
  ServerData.StatData = {}
  ServerData.MissionData = {}
  ServerData.StatDataLastType = {}
  ServerData.PlayersTableCache = {}
  ServerData.SlotsData = {}
end
