--################################ 辅助函数定义(Helper function definitions) ################################
-- Object.Category { UNIT = 1, WEAPON = 2,STATIC = 3, BASE = 4,SCENERY = 5, Cargo = 6}
-- Helper function returns object category basing on https://pastebin.com/GUAXrd2U

---返回基于的对象单位类别
---@param id any
---@return string
ServerData.GetCategory = function(id)
  -- Helper function returns object category basing on https://pastebin.com/GUAXrd2U
  local _killed_target_category = 'Other'
  -- Sometimes we get empty object id (seems like DCS API bug)
  -- 有时我们会得到空的对象ID（似乎是DCS API错误）
  if id ~= nil and id ~= '' then
    _killed_target_category = DCS.getUnitTypeAttribute(id, 'category')
    -- Below, simple hack to get the propper category when DCS API is not returning correct value
    --下面是简单的技巧可在DCS API未返回正确值时获得正确的类别
    if _killed_target_category == nil then
      local _killed_target_cat_check_ship = DCS.getUnitTypeAttribute(id, 'DeckLevel')
      local _killed_target_cat_check_plane = DCS.getUnitTypeAttribute(id, 'WingSpan')
      if _killed_target_cat_check_ship ~= nil and _killed_target_cat_check_plane == nil then
        _killed_target_category = 'Ships'
      elseif _killed_target_cat_check_ship == nil and _killed_target_cat_check_plane ~= nil then
        _killed_target_category = 'Planes'
      else
        _killed_target_category = 'Helicopters'
      end
    end
  end
  return _killed_target_category
end

---获取阵营名称
---@param id number --side id
---@return any --  阵营名称
ServerData.SideID2Name = function(id)
  -- Helper function returns side name per side (coalition) id
  -- Helper函数按阵营返回每个阵营的名称(coalition) id
  local _sides = {
    [0] = 'SPECTATOR',
    [1] = 'RED',
    [2] = 'BLUE',
    [3] = 'NEUTRAL' -- TBD check once this is released in DCS
  }
  if id > 0 and id <= 3 then
    return _sides[id]
  else
    return '?'
  end
end

---生成唯一的模拟任务哈希
---@return string
ServerData.GenerateMissionHash = function()
  -- Generates unique simulation mission hash
  return DCS.getMissionName() .. '@' .. ServerData.Version .. '@' .. os.date('%Y%m%d_%H%M%S')
end

---获取多机组人员所有参数
---@param PlayerId number --玩家ID
---@return string --_master_type 单位类型
---@return nil --_master_slot
---@return nil --_sub_slot
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
---@return any
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

---获取所有多机组人员
---@param owner_playerID any 所有者玩家ID
---@return table 所有者玩家
ServerData.GetMulticrewCrew = function(owner_playerID)
  -- Get all multicrew crew
  -- 获取所有多机组人员
  local _master_type, _master_slot, _sub_slot = ServerData.GetMulticrewAllParameters(owner_playerID)
  local _crew = {}
  table.insert(_crew, owner_playerID)
  if
    _master_type == 'F-14B' or _master_type == 'Yak-52' or _master_type == 'L-39C' or _master_type == 'SA342M' or _master_type == 'SA342Minigun' or _master_type == 'SA342Mistral' or _master_type == 'SA342L' or _master_type == 'F-14A-135-GR' or _master_type == 'C-101EB' or _master_type == 'UH-1H' or
      _master_type == 'C-101CC'
   then
    -- TBD add additional multicrew model types
    -- TBD添加额外的多机组模型类型
    local _owner_side = net.get_player_info(owner_playerID, 'side')

    if _master_slot and _master_slot ~= '' then
      -- Search for all players from crew
      -- 从所有玩家搜索机组人员
      local _all_players = net.get_player_list()
      for PlayerIDIndex, _playerID in ipairs(_all_players) do
        local _playerDetails = net.get_player_info(_playerID)
        if
          _playerDetails.side == _owner_side and (_playerDetails.slot == _master_slot or _playerDetails.slot == _master_slot .. '_1' or _playerDetails.slot == _master_slot .. '_2' or _playerDetails.slot == _master_slot .. '_3' or _playerDetails.slot == _master_slot .. '_4') and
            _playerID ~= owner_playerID
         then
          -- Add to crew list
          -- 添加到机组人员列表
          table.insert(_crew, _playerID)
        else
          -- Do nothing
        end
      end
    end
  end

  Logger.AddLog('Multicrew check completed: ' .. net.lua2json(_crew), 2)
  return _crew
end
---获取所有机组人员名称并以字符串形式返回(用于记录目的)
---@param owner_playerID any --所有者玩家ID
---@return string 所有机组人员名称
ServerData.GetMulticrewCrewNames = function(owner_playerID)
  -- Get all crew names and return as string (needed for logging purposes)
  -- 获取所有机组人员名称并以字符串形式返回(用于记录目的)
  local _pilots_accounted = ServerData.GetMulticrewCrew(owner_playerID)
  local _result_text = ''
  for _, pilotID in ipairs(_pilots_accounted) do
    _result_text = _result_text .. net.get_player_info(pilotID, 'name') .. ', '
  end
  return _result_text
end
---获取起飞降落事件
---@param takeoff any
---@param location any --地点
---@return string 起飞或者降落在哪里
ServerData.GetTakeOffLandingEvent = function(takeoff, location)
  -- Get correct event type for statistics basing on objecy which served as runway/farp
  -- 根据 served 和 runway/farp对象获取正确的事件类型以进行统计
  local _operation = ''
  if takeoff == true then
    _operation = 'tookoff_'
  else
    _operation = 'landing_'
  end

  local _temp_type = ''
  if string.find(location, 'FARP', 1, true) then
    _temp_type = 'FARP'
  elseif string.find(location, 'CVN-74 John C. Stennis', 1, true) or string.find(location, 'LHA-1 Tarawa', 1, true) or string.find(location, 'SHIP', 1, true) then
    _temp_type = 'SHIP'
  elseif location ~= '' then
    _temp_type = 'AIRFIELD'
  else
    _temp_type = 'OTHER'
  end

  return _operation .. _temp_type
end
-- ################################ 日志功能(Log functions) ################################

---聊天日志
---@param playerID any
---@param msg any
---@param all any
ServerData.LogChat = function(playerID, msg, all)
  -- Logs chat messages
  local _TempData = {}
  _TempData['player'] = net.get_player_info(playerID, 'name')
  _TempData['msg'] = msg
  _TempData['all'] = all
  _TempData['ucid'] = net.get_player_info(playerID, 'ucid')
  _TempData['datetime'] = os.date('%Y-%m-%d %H:%M:%S')
  _TempData['missionhash'] = ServerData.MissionHash
  ServerData.client_send_msg('LogChat', _TempData)
  Logger.AddLog(_TempData, 1)
end
---事件日志
---@param log_type string 事件类型
---@param log_content string 日志内容
---@param log_arg_1 any
---@param log_arg_2 any
ServerData.LogEvent = function(log_type, log_content, log_arg_1, log_arg_2)
  -- Logs events messages
  -- 记录事件消息
  local _TempData = {}
  _TempData['log_type'] = log_type
  _TempData['log_arg_1'] = log_arg_1
  _TempData['log_arg_2'] = log_arg_2
  _TempData['log_content'] = log_content
  _TempData['log_datetime'] = os.date('%Y-%m-%d %H:%M:%S')
  _TempData['log_missionhash'] = ServerData.MissionHash
  if log_arg_1 == nil then
    log_arg_1 = 'null'
  end
  if log_arg_2 == nil then
    log_arg_2 = 'null'
  end

  Logger.AddLog('event: ' .. log_type .. ', arg1:' .. log_arg_1 .. ', arg2:' .. log_arg_2 .. ', content: ' .. log_content, 1)
  ServerData.client_send_msg('LogEvent', _TempData)
end
---记录单个玩家数据
---@param playerID any --玩家ID
---@param event string --事件名称
ServerData.LogStats = function(playerID, event)
  -- Log player status
  local _PlayerStatsTable = ServerData.LogStatsGet(playerID)
  local _TempData = {}
  _TempData['stat_data_ServerData'] = _PlayerStatsTable
  _TempData['stat_data_type'] = _PlayerStatsTable['subtype']
  _TempData['stat_data_masterslot'] = _PlayerStatsTable['masterslot']
  _TempData['stat_data_subslot'] = _PlayerStatsTable['subslot']
  _TempData['stat_ucid'] = _PlayerStatsTable['ucid']
  _TempData['stat_name'] = _PlayerStatsTable['name']
  _TempData['stat_datetime'] = os.date('%Y-%m-%d %H:%M:%S')
  _TempData['stat_missionhash'] = ServerData.MissionHash
  Logger.AddLog('Sending stats data', 1)
  if event ~= nil then
    ServerData.client_send_msg('LogStats', _TempData)
  else
    ServerData.client_send_msg(event, _TempData)
  end
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

---记录玩家登录数据
---@param playerID any
ServerData.LogLogin = function(playerID)
  -- Player logged in
  local _TempData = {}
  _TempData['name'] = net.get_player_info(playerID, 'name')
  _TempData['ucid'] = net.get_player_info(playerID, 'ucid')
  _TempData['lang'] = net.get_player_info(playerID, 'lang')
  _TempData['ping'] = net.get_player_info(playerID, 'ping')
  _TempData['ipaddr'] = net.get_player_info(playerID, 'ipaddr')
  Logger.AddLog('Sending login event', 1)
  ServerData.client_send_msg('playerLogin', _TempData)
end

-- ################################ Calculate stats(计算统计) ################################

---创建或更新ServerData统计信息数组
---@param argPlayerID any
---@param argAction any
---@param argTimer any
ServerData.LogStatsCount = function(argPlayerID, argAction, argTimer)
  -- Creates or updates ServerData statistics array
  -- 创建或更新ServerData统计信息数组
  local _player_hash = net.get_player_info(argPlayerID, 'ucid') .. ServerData.GetMulticrewParameter(argPlayerID, 'subtype')
  -- By default we will be sending stats
  -- 默认情况下，我们将发送统计信息
  argTimer = argTimer or false

  if ServerData.StatData[_player_hash] == nil then
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

    ServerData.StatData[_player_hash] = _TempData
  end

  if ServerData.GetMulticrewParameter(argPlayerID, 'subtype') ~= nil then
    ServerData.StatDataLastType[net.get_player_info(argPlayerID, 'ucid')] = _player_hash
  else
    -- Do nothing
  end

  if argAction == 'eject' then
    ServerData.StatData[_player_hash]['ejections'] = ServerData.StatData[_player_hash]['ejections'] + 1
  elseif argAction == 'pilot_death' then
    if DCS.getModelTime() > ServerData.MissionStartNoDeathWindow then
      -- we do not track deaths during mission startup due to spawning issues
      ServerData.StatData[_player_hash]['deaths'] = ServerData.StatData[_player_hash]['deaths'] + 1
    end
  elseif argAction == 'friendly_fire' then
    ServerData.StatData[_player_hash]['teamkills'] = ServerData.StatData[_player_hash]['teamkills'] + 1
  elseif argAction == 'crash' then
    ServerData.StatData[_player_hash]['crashes'] = ServerData.StatData[_player_hash]['crashes'] + 1
  elseif argAction == 'landing_FARP' then
    ServerData.StatData[_player_hash]['farp_landings'] = ServerData.StatData[_player_hash]['farp_landings'] + 1
  elseif argAction == 'landing_SHIP' then
    ServerData.StatData[_player_hash]['ship_landings'] = ServerData.StatData[_player_hash]['ship_landings'] + 1
  elseif argAction == 'landing_AIRFIELD' then
    ServerData.StatData[_player_hash]['airfield_landings'] = ServerData.StatData[_player_hash]['airfield_landings'] + 1
  elseif argAction == 'tookoff_FARP' then
    ServerData.StatData[_player_hash]['farp_takeoffs'] = ServerData.StatData[_player_hash]['farp_takeoffs'] + 1
  elseif argAction == 'tookoff_SHIP' then
    ServerData.StatData[_player_hash]['ship_takeoffs'] = ServerData.StatData[_player_hash]['ship_takeoffs'] + 1
  elseif argAction == 'tookoff_AIRFIELD' then
    ServerData.StatData[_player_hash]['airfield_takeoffs'] = ServerData.StatData[_player_hash]['airfield_takeoffs'] + 1
  elseif argAction == 'kill_Planes' then
    ServerData.StatData[_player_hash]['kills_planes'] = ServerData.StatData[_player_hash]['kills_planes'] + 1
  elseif argAction == 'kill_Helicopters' then
    ServerData.StatData[_player_hash]['kills_helicopters'] = ServerData.StatData[_player_hash]['kills_helicopters'] + 1
  elseif argAction == 'kill_Ships' then
    ServerData.StatData[_player_hash]['kills_ships'] = ServerData.StatData[_player_hash]['kills_ships'] + 1
  elseif argAction == 'kill_Air_Defence' then
    ServerData.StatData[_player_hash]['kills_air_defense'] = ServerData.StatData[_player_hash]['kills_air_defense'] + 1
  elseif argAction == 'kill_Unarmed' then
    ServerData.StatData[_player_hash]['kills_unarmed'] = ServerData.StatData[_player_hash]['kills_unarmed'] + 1
  elseif argAction == 'kill_Armor' then
    ServerData.StatData[_player_hash]['kills_armor'] = ServerData.StatData[_player_hash]['kills_armor'] + 1
  elseif argAction == 'kill_Infantry' then
    ServerData.StatData[_player_hash]['kills_infantry'] = ServerData.StatData[_player_hash]['kills_infantry'] + 1
  elseif argAction == 'kill_Fortification' then
    ServerData.StatData[_player_hash]['kills_fortification'] = ServerData.StatData[_player_hash]['kills_fortification'] + 1
  elseif argAction == 'kill_Artillery' then
    ServerData.StatData[_player_hash]['kills_artillery'] = ServerData.StatData[_player_hash]['kills_artillery'] + 1
  elseif argAction == 'kill_Other' then
    ServerData.StatData[_player_hash]['kills_other'] = ServerData.StatData[_player_hash]['kills_other'] + 1
  elseif argAction == 'kill_PvP' then
    ServerData.StatData[_player_hash]['pvp'] = ServerData.StatData[_player_hash]['pvp'] + 1
  elseif argAction == 'landing_OTHER' then
    ServerData.StatData[_player_hash]['other_landings'] = ServerData.StatData[_player_hash]['other_landings'] + 1
  elseif argAction == 'tookoff_OTHER' then
    ServerData.StatData[_player_hash]['other_takeoffs'] = ServerData.StatData[_player_hash]['other_takeoffs'] + 1
  elseif argAction == 'timer' then
    ServerData.StatData[_player_hash]['time'] = ServerData.StatData[_player_hash]['time'] + 1
  end

  -- Always update slots
  ServerData.StatData[_player_hash]['masterslot'] = ServerData.GetMulticrewParameter(argPlayerID, 'masterslot')
  ServerData.StatData[_player_hash]['subslot'] = ServerData.GetMulticrewParameter(argPlayerID, 'subslot')

  Logger.AddLog('Stats data prepared', 2)

  -- If this is timer request do not send data to database
  if argTimer ~= true then
    ServerData.LogStats(argPlayerID)
  end
end
---记录统计所有玩家
---@param MasterPilotID any
---@param ActionType any
ServerData.LogStatsCountCrew = function(MasterPilotID, ActionType)
  -- Change stats for the whole crew
  -- 更改全体玩家的统计数据
  local _pilots_accounted = ServerData.GetMulticrewCrew(MasterPilotID)
  for _, pilotID in ipairs(_pilots_accounted) do
    ServerData.LogStatsCount(pilotID, ActionType)
  end
end
-- ################################ Data preparation ################################
---获取每个玩家的ServerData统计信息数组
---@param playerID string
---@return any
ServerData.LogStatsGet = function(playerID)
  -- Gets ServerData statistics array per player
  local _now = DCS.getRealTime()

  local _player_hash = nil
  local _ucid = net.get_player_info(playerID, 'ucid')
  if not _ucid then
    _ucid = ServerData.PlayersTableCache['p' .. playerID].ucid
  end

  if ServerData.isEmptytb(ServerData.StatDataLastType) then
    -- Array is empty
    _player_hash = _ucid .. ServerData.GetMulticrewParameter(playerID, 'subtype')
  elseif ServerData.StatDataLastType[net.get_player_info(playerID, 'ucid')] == nil then
    -- Last type entry is empty
    _player_hash = _ucid .. ServerData.GetMulticrewParameter(playerID, 'subtype')
  else
    -- Return last type entry
    _player_hash = ServerData.StatDataLastType[_ucid]
  end

  if ServerData.isEmptytb(ServerData.StatData) then
    -- Array is empty
    ServerData.LogStatsCount(playerID, 'init') -- Init statistics
  end
  if ServerData.StatData[_player_hash] == nil then
    -- Stats for player are empty
    ServerData.LogStatsCount(playerID, 'init') -- Init statistics
  end

  local _delay = (DCS.getRealTime() - _now) * 1000000
  Logger.AddLog('Getting stats data finished; took: ' .. _delay .. 'us', 2)
  return ServerData.StatData[_player_hash]
end
---状态更新的主要功能
ServerData.UpdateStatus = function()
  -- Main function for status updates
  local _now = DCS.getRealTime()
  -- Diagnostic data
  -- Update version data
  local _ServerData = {}
  _ServerData['v_dcs_hook'] = ServerData.Version
  -- Update clients data - count connected players
  local _playerlist = net.get_player_list()
  _ServerData['count_players'] = #_playerlist
  ServerData.StatusData['server'] = _ServerData
  -- Mission data
  local _MissionData = {}
  _MissionData['name'] = DCS.getMissionName()
  _MissionData['modeltime'] = DCS.getModelTime()
  _MissionData['realtime'] = DCS.getRealTime()
  _MissionData['pause'] = DCS.getPause()
  _MissionData['multiplayer'] = DCS.isMultiplayer()
  _MissionData['theatre'] = ServerData.MissionData['theatre']
  ServerData.StatusData = _MissionData
  -- Players data
  local _PlayersTable = {}
  for _k, _i in ipairs(_playerlist) do
    _PlayersTable[_k] = net.get_player_info(_i)
    _PlayersTable[_k]['pilotid'] = nil
    _PlayersTable[_k]['started'] = nil
    _PlayersTable[_k]['lang'] = nil
    _PlayersTable[_k]['ipaddr'] = nil
  end
  ServerData.StatusData['clients'] = _PlayersTable
  -- Send
  local _delay = (DCS.getRealTime() - _now) * 1000000
  Logger.AddLog('Updated status data; sending (' .. _delay .. 'us)', 2)
  ServerData.client_send_msg('UpdateStatus', ServerData.StatusData)
end
---更新并发送插槽数据
ServerData.UpdateSlots = function()
  -- Update and send slots data
  local _now = DCS.getRealTime()
  -- Check if we need to pull the data or we can use the stored one
  -- 检查是否需要提取数据，或者我们可以使用存储的数据
  if ServerData.SlotsData['coalitions'] == nil then
    ServerData.SlotsData['coalitions'] = DCS.getAvailableCoalitions()
    ServerData.SlotsData['slots'] = {}
    -- Build up slot table
    -- 建立插槽表
    for _j, _i in pairs(ServerData.SlotsData['coalitions']) do
      ServerData.SlotsData['slots'][_j] = DCS.getAvailableSlots(_j)
      for _sj, _si in pairs(ServerData.SlotsData['slots'][_j]) do
        ServerData.SlotsData['slots'][_j][_sj]['countryName'] = nil
        ServerData.SlotsData['slots'][_j][_sj]['onboard_num'] = nil
        ServerData.SlotsData['slots'][_j][_sj]['groupSize'] = nil
        ServerData.SlotsData['slots'][_j][_sj]['groupName'] = nil
        ServerData.SlotsData['slots'][_j][_sj]['callsign'] = nil
        ServerData.SlotsData['slots'][_j][_sj]['task'] = nil
        ServerData.SlotsData['slots'][_j][_sj]['airdromeId'] = nil
        ServerData.SlotsData['slots'][_j][_sj]['helipadName'] = nil
        ServerData.SlotsData['slots'][_j][_sj]['multicrew_place'] = nil
        ServerData.SlotsData['slots'][_j][_sj]['role'] = nil
        ServerData.SlotsData['slots'][_j][_sj]['helipadUnitType'] = nil
        ServerData.SlotsData['slots'][_j][_sj]['action'] = nil
      end
    end
  end

  local _delay = (DCS.getRealTime() - _now) * 1000000
  Logger.AddLog('Updated slots data; sending (' .. _delay .. 'us)', 2)
  ServerData.client_send_msg('UpdateSlots', ServerData.SlotsData)
end
---任务信息更新的主要功能
ServerData.UpdateMission = function()
  -- Main function for mission information updates
  local _now = DCS.getRealTime()
  -- Check if we need to get mission data
  -- 检查我们是否需要获取任务数据
  if ServerData.isEmptytb(ServerData.MissionData) then
    local mission = DCS.getCurrentMission()['mission']
    local date = os.time {year = mission['date'].Year, month = mission['date'].Month, day = mission['date'].Day}
    ServerData.MissionData = {
      name = DCS.getMissionName(), --返回当前任务的名称
      filename = DCS.getMissionFilename(), --返回当前任务的文件名
      description = DCS.getMissionDescription(), --任务描述
      theatre = mission['theatre'],
      map = mission['map'],
      coalition = mission['coalition'],
      result_red = DCS.getMissionResult('red'),
      result_blue = DCS.getMissionResult('blue'),
      missionhash = ServerData.MissionHash,
      date = os.date('%Y-%m-%d', date)
    }
  --[[
      --返回阵营可用插槽列表。
      DCS.getAvailableCoalitions()
      --获取指定阵营的可用插槽(注意:返回的unitID实际上是一个slotID,对于多座单位它是
      DCS.getAvailableSlots(coalitionID) 'unitID_seatID')
      --获取单位属性
      DCS.getUnitProperty(missionId, propertyId)
      --从配置状态读取一个值。
      DCS.getConfigValue(cfg_path_string)
      -> {{abstime,级别,子系统,消息},...},last_index 返回从给定索引开始的最新日志消息。
      DCS.getLogHistory(from)
      Usage:
      local result = {}
      local id_from = 0
      local logHistory = {}
      local logIndex = 0
      logHistory, logIndex = DCS.getLogHistory(id_from)
      result = {
        logHistory = logHistory,
        new_last_id = logIndex
      }
      return result
     --log.write('WebGUI', log.DEBUG, string.format('%s returned %s!', requestString, net.lua2json(result)))
  --]]
  end
  local _delay = (DCS.getRealTime() - _now) * 1000000
  Logger.AddLog('Updated mission data; sending (' .. _delay .. 'us)', 2)
  ServerData.client_send_msg('UpdateMission', ServerData.MissionData)
end
