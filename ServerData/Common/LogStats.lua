-- ################################ Calculate stats(计算统计) ################################
---获取多机组人员所有参数
---@param PlayerId number --玩家ID
---@return any --_master_type --单位类型
---@return any --_master_slot --主驾驶座位号
---@return any --_sub_slot --副驾驶座位号
ServerData.GetMulticrewAllParameters = function(PlayerId)
  -- Gets all multicrew parameters
  local _master_type = '?'
  local _master_slot = nil
  local _sub_slot = nil
  local _player_slot = net.get_player_info(PlayerId, 'slot')
  if not _player_slot then
    _player_slot = ServerData.PlayersTableCache['p' .. PlayerId].slot
  end
  if _player_slot and _player_slot ~= '' and not (string.find(_player_slot, 'red') or string.find(_player_slot, 'blue')) then
    -- Player took model
    _master_slot = _player_slot
    _sub_slot = 0

    if (not tonumber(_player_slot)) then
      -- If this is multiseat slot parse master slot and look for seat number
      -- 如果这是多机组插槽，请解析主插槽并查找座位号
      local _t_start, _t_end = string.find(_player_slot, '_%d+')

      if _t_start then
        -- This is co-player
        -- 多机组人员
        _master_slot = string.sub(_player_slot, 0, _t_start - 1)
        _sub_slot = string.sub(_player_slot, _t_start + 1, _t_end)
      end
    end
    _master_type = DCS.getUnitType(_master_slot)
  elseif string.find(_player_slot, 'red') or string.find(_player_slot, 'blue') then
    -- Deal with the special slots addded by Combined Arms and Spectators
    -- 处理多人员和旁观者添加的特殊插槽
    if string.find(_player_slot, 'artillery_commander') then
      _master_type = 'artillery_commander'
    elseif string.find(_player_slot, 'instructor') then
      _master_type = 'instructor'
    elseif string.find(_player_slot, 'forward_observer') then
      _master_type = 'forward_observer'
    elseif string.find(_player_slot, 'observer') then
      _master_type = 'observer'
    end
    _master_slot = -1
    _sub_slot = 0
  else
    _master_slot = -1
    _sub_slot = -1
  end
  return _master_type, _master_slot, _sub_slot
end

---获取多机组人员特定参数
---@param PlayerId any --玩家ID
---@param Parameter any --需要获取参数
---@return any  --如果是多人机组将返回多
ServerData.GetMulticrewParameter = function(PlayerId, Parameter)
  -- Get specific multicrew Parameter
  local _master_type, _master_slot, _sub_slot = ServerData.GetMulticrewAllParameters(PlayerId)
  if Parameter == 'mastertype' then
    return _master_type
  elseif Parameter == 'masterslot' then
    return _master_slot
  elseif Parameter == 'subslot' then
    return _sub_slot
  elseif Parameter == 'subtype' then
    if _sub_slot == 0 then
      return _master_type
    else
      return _master_type .. '_' .. _sub_slot
    end
  else
    return nil
  end
end

---创建或更新ServerData统计信息数组
---@param argPlayerID any
---@param argAction any
ServerData.LogStatsCount = function(argPlayerID, argAction)
  -- Creates or updates ServerData statistics array
  -- 创建或更新ServerData统计信息数组
  local ucid = net.get_player_info(argPlayerID, 'ucid')
  if ucid == nil then
    return
  end
  if ServerData.StatData[ucid] == nil or ServerData.StatData[ucid]['gameInfo'] == nil then
    -- Create empty element
    -- 创建空元素
    local _TempData = {}
    _TempData['ucid'] = net.get_player_info(argPlayerID, 'ucid')
    _TempData['name'] = net.get_player_info(argPlayerID, 'name')
    _TempData['subtype'] = ServerData.GetMulticrewParameter(argPlayerID, 'subtype')
    _TempData['masterslot'] = ServerData.GetMulticrewParameter(argPlayerID, 'masterslot')
    _TempData['subslot'] = ServerData.GetMulticrewParameter(argPlayerID, 'subslot')
    _TempData['pvp'] = 0
    _TempData['deaths'] = 0
    _TempData['ejections'] = 0
    _TempData['crashes'] = 0
    _TempData['teamkills'] = 0
    _TempData['time'] = 0
    _TempData['kills_planes'] = 0
    _TempData['kills_helicopters'] = 0
    _TempData['kills_air_defense'] = 0
    _TempData['kills_armor'] = 0
    _TempData['kills_unarmed'] = 0
    _TempData['kills_infantry'] = 0
    _TempData['kills_ships'] = 0
    _TempData['kills_fortification'] = 0
    _TempData['kills_artillery'] = 0
    _TempData['kills_other'] = 0
    _TempData['airfield_takeoffs'] = 0
    _TempData['airfield_landings'] = 0
    _TempData['ship_takeoffs'] = 0
    _TempData['ship_landings'] = 0
    _TempData['farp_takeoffs'] = 0
    _TempData['farp_landings'] = 0
    _TempData['other_takeoffs'] = 0
    _TempData['other_landings'] = 0
    ServerData.SinglePlayer['gameInfo'] = _TempData
    ServerData.StatData[ucid] = ServerData.SinglePlayer
  end

  if ServerData.GetMulticrewParameter(argPlayerID, 'subtype') ~= nil then
    ServerData.StatDataLastType[net.get_player_info(argPlayerID, 'ucid')] = ucid
  else
    -- Do nothing
  end
  if argAction == 'eject' then
    ServerData.StatData[ucid]['gameInfo']['ejections'] = ServerData.StatData[ucid]['gameInfo']['ejections'] + 1
  elseif argAction == 'pilot_death' then
    if DCS.getModelTime() > ServerData.MissionStartNoDeathWindow then
      -- we do not track deaths during mission startup due to spawning issues
      ServerData.StatData[ucid]['gameInfo']['deaths'] = ServerData.StatData[ucid]['gameInfo']['deaths'] + 1
    end
  elseif argAction == 'friendly_fire' then
    ServerData.StatData[ucid]['gameInfo']['teamkills'] = ServerData.StatData[ucid]['gameInfo']['teamkills'] + 1
  elseif argAction == 'crash' then
    ServerData.StatData[ucid]['gameInfo']['crashes'] = ServerData.StatData[ucid]['gameInfo']['crashes'] + 1
  elseif argAction == 'landing_FARP' then
    ServerData.StatData[ucid]['gameInfo']['farp_landings'] = ServerData.StatData[ucid]['gameInfo']['farp_landings'] + 1
  elseif argAction == 'landing_SHIP' then
    ServerData.StatData[ucid]['gameInfo']['ship_landings'] = ServerData.StatData[ucid]['gameInfo']['ship_landings'] + 1
  elseif argAction == 'landing_AIRFIELD' then
    ServerData.StatData[ucid]['gameInfo']['airfield_landings'] = ServerData.StatData[ucid]['gameInfo']['airfield_landings'] + 1
  elseif argAction == 'tookoff_FARP' then
    ServerData.StatData[ucid]['gameInfo']['farp_takeoffs'] = ServerData.StatData[ucid]['gameInfo']['farp_takeoffs'] + 1
  elseif argAction == 'tookoff_SHIP' then
    ServerData.StatData[ucid]['gameInfo']['ship_takeoffs'] = ServerData.StatData[ucid]['gameInfo']['ship_takeoffs'] + 1
  elseif argAction == 'tookoff_AIRFIELD' then
    ServerData.StatData[ucid]['gameInfo']['airfield_takeoffs'] = ServerData.StatData[ucid]['gameInfo']['airfield_takeoffs'] + 1
  elseif argAction == 'kill_Planes' then
    ServerData.StatData[ucid]['gameInfo']['kills_planes'] = ServerData.StatData[ucid]['gameInfo']['kills_planes'] + 1
  elseif argAction == 'kill_Helicopters' then
    ServerData.StatData[ucid]['gameInfo']['kills_helicopters'] = ServerData.StatData[ucid]['gameInfo']['kills_helicopters'] + 1
  elseif argAction == 'kill_Ships' then
    ServerData.StatData[ucid]['gameInfo']['kills_ships'] = ServerData.StatData[ucid]['gameInfo']['kills_ships'] + 1
  elseif argAction == 'kill_Air_Defence' then
    ServerData.StatData[ucid]['gameInfo']['kills_air_defense'] = ServerData.StatData[ucid]['gameInfo']['kills_air_defense'] + 1
  elseif argAction == 'kill_Unarmed' then
    ServerData.StatData[ucid]['gameInfo']['kills_unarmed'] = ServerData.StatData[ucid]['gameInfo']['kills_unarmed'] + 1
  elseif argAction == 'kill_Armor' then
    ServerData.StatData[ucid]['gameInfo']['kills_armor'] = ServerData.StatData[ucid]['gameInfo']['kills_armor'] + 1
  elseif argAction == 'kill_Infantry' then
    ServerData.StatData[ucid]['gameInfo']['kills_infantry'] = ServerData.StatData[ucid]['gameInfo']['kills_infantry'] + 1
  elseif argAction == 'kill_Fortification' then
    ServerData.StatData[ucid]['gameInfo']['kills_fortification'] = ServerData.StatData[ucid]['gameInfo']['kills_fortification'] + 1
  elseif argAction == 'kill_Artillery' then
    ServerData.StatData[ucid]['gameInfo']['kills_artillery'] = ServerData.StatData[ucid]['gameInfo']['kills_artillery'] + 1
  elseif argAction == 'kill_Other' then
    ServerData.StatData[ucid]['gameInfo']['kills_other'] = ServerData.StatData[ucid]['gameInfo']['kills_other'] + 1
  elseif argAction == 'kill_PvP' then
    ServerData.StatData[ucid]['gameInfo']['pvp'] = ServerData.StatData[ucid]['gameInfo']['pvp'] + 1
  elseif argAction == 'landing_OTHER' then
    ServerData.StatData[ucid]['gameInfo']['other_landings'] = ServerData.StatData[ucid]['gameInfo']['other_landings'] + 1
  elseif argAction == 'tookoff_OTHER' then
    ServerData.StatData[ucid]['gameInfo']['other_takeoffs'] = ServerData.StatData[ucid]['gameInfo']['other_takeoffs'] + 1
  elseif argAction == 'timer' then
    ServerData.StatData[ucid]['gameInfo']['time'] = ServerData.StatData[ucid]['gameInfo']['time'] + 1
  end
  -- Always update slots
  ServerData.StatData[ucid]['gameInfo']['masterslot'] = ServerData.GetMulticrewParameter(argPlayerID, 'masterslot')
  ServerData.StatData[ucid]['gameInfo']['subslot'] = ServerData.GetMulticrewParameter(argPlayerID, 'subslot')
end

---记录单个玩家数据
---@param playerID any --玩家ID
---@param event string --事件名称
ServerData.LogStats = function(playerID, event)
  -- Log player status
  local _PlayerStatsTable = ServerData.LogStatsGet(playerID)
  local _TempData = {}
  _TempData['stat_data'] = _PlayerStatsTable
  _TempData['stat_data_type'] = _PlayerStatsTable['subtype']
  _TempData['stat_data_masterslot'] = _PlayerStatsTable['masterslot']
  _TempData['stat_data_subslot'] = _PlayerStatsTable['subslot']
  _TempData['stat_ucid'] = _PlayerStatsTable['ucid']
  _TempData['stat_name'] = _PlayerStatsTable['name']
  _TempData['stat_datetime'] = os.date('%Y-%m-%d %H:%M:%S')
  _TempData['stat_missionhash'] = ServerData.MissionHash

  if event ~= nil then
    ServerData.client_send_msg(event, _TempData)
  else
    ServerData.client_send_msg('LogStats', _TempData)
  end
end

---获取每个玩家的ServerData统计信息数组
---@param playerID string
---@return any
ServerData.LogStatsGet = function(playerID)
  -- Gets ServerData statistics array per player
  local ucid = net.get_player_info(playerID, 'ucid')
  if not ucid then
    ucid = ServerData.PlayersTableCache['p' .. playerID].ucid
  end
  if ServerData.isEmptytb(ServerData.StatData) then
    -- Array is empty
    ServerData.LogStatsCount(playerID, 'init') -- Init statistics
  end
  if ServerData.StatData[ucid] == nil then
    -- Stats for player are empty
    ServerData.LogStatsCount(playerID, 'init') -- Init statistics
  end
  return ServerData.StatData
end
---记录所有玩家数据
ServerData.LogAllStats = function()
  -- Log all players data
  local _all_players = net.get_player_list()
  for PlayerIDIndex, _playerID in ipairs(_all_players) do
    if _playerID ~= 1 then
      ServerData.LogStats(_playerID, 'LogAllStats')
    end
  end
end
---记录统计玩家所有信息
---@param MasterPilotID any
---@param ActionType any
ServerData.LogStatsCountCrew = function(MasterPilotID, ActionType)
  -- Change stats for the whole crew
  -- 更改玩家所有信息的统计数据
  local _pilots_accounted = ServerData.GetMulticrewCrew(MasterPilotID)
  for _, pilotID in ipairs(_pilots_accounted) do
    ServerData.LogStatsCount(pilotID, ActionType)
  end
end
