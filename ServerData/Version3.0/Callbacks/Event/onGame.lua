ServerData.callbacks.onGameEvent = function(eventName, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
  -- Game event has occured
  -- 发生了游戏事件
  local _now = DCS.getRealTime()
  local _temp_killers = ' AI '
  local _temp_event_type = ''
  local _temp_category = ''
  local _temp_airfield = ''
  Logger.AddLog('Event handler for ' .. eventName .. ' started', 2)
  if eventName == 'friendly_fire' then
    --"friendly_fire", playerID, weaponName, victimPlayerID
    if arg2 == '' then
      arg2 = 'Cannon'
    end
    ServerData.LogEvent(eventName, ServerData.SideID2Name(net.get_player_info(arg1, 'side')) .. ' player(s) ' .. ServerData.GetMulticrewCrewNames(arg1) .. ' killed friendly ' .. ServerData.GetMulticrewCrewNames(arg3) .. ' using ' .. arg2, nil, nil)
  elseif eventName == 'mission_end' then
    --"mission_end", winner, msg
    ServerData.LogEvent(eventName, 'Mission finished, winner ' .. arg1 .. ' message: ' .. arg2, nil, nil)
  elseif eventName == 'kill' then
    --"kill", killerPlayerID, killerUnitType, killerSide, victimPlayerID, victimUnitType, victimSide, weaponName
    local _temp_victims = ''
    if net.get_player_info(arg4, 'name') ~= nil then
      _temp_victims = ' player(s) ' .. ServerData.GetMulticrewCrewNames(arg4) .. ' '

      ServerData.LogStats(arg4)
    else
      _temp_victims = ' AI '
    end

    if net.get_player_info(arg1, 'name') ~= nil then
      _temp_killers = ' player(s) ' .. ServerData.GetMulticrewCrewNames(arg1) .. ' '

      if arg3 ~= arg6 then
        _temp_category = ServerData.GetCategory(arg5)

        if _temp_category == 'Planes' then
          _temp_event_type = 'kill_Planes'
        elseif _temp_category == 'Helicopters' then
          _temp_event_type = 'kill_Helicopters'
        elseif _temp_category == 'Ships' then
          _temp_event_type = 'kill_Ships'
        elseif _temp_category == 'Air Defence' then
          _temp_event_type = 'kill_Air_Defence'
        elseif _temp_category == 'Unarmed' then
          _temp_event_type = 'kill_Unarmed'
        elseif _temp_category == 'Armor' then
          _temp_event_type = 'kill_Armor'
        elseif _temp_category == 'Infantry' then
          _temp_event_type = 'kill_Infantry'
        elseif _temp_category == 'Fortification' then
          _temp_event_type = 'kill_Fortification'
        elseif _temp_category == 'Artillery' or _temp_category == 'MissilesSS' then
          _temp_event_type = 'kill_Artillery'
        else
          _temp_event_type = 'kill_Other'
        end
        if net.get_player_info(arg4, 'name') ~= nil and arg3 ~= arg6 then
          ServerData.LogStatsCountCrew(arg1, 'kill_PvP')
        end
      else
        _temp_event_type = 'friendly_fire'
      end
      ServerData.LogStatsCountCrew(arg1, _temp_event_type)
    end

    if arg7 == '' then
      arg7 = 'Cannon'
    end

    local victim_vehicle = arg5
    if victim_vehicle == '' then
      victim_vehicle = '?'
    end

    ServerData.LogEvent(eventName, ServerData.SideID2Name(arg3) .. _temp_killers .. ' in ' .. arg2 .. ' killed ' .. ServerData.SideID2Name(arg6) .. _temp_victims .. ' in ' .. victim_vehicle .. ' using ' .. arg7 .. ' [' .. ServerData.GetCategory(arg5) .. ']', arg7, ServerData.GetCategory(arg5))
  elseif eventName == 'self_kill' then
    --"self_kill", playerID
    ServerData.LogStats(arg1)
    ServerData.LogEvent(eventName, net.get_player_info(arg1, 'name') .. ' killed himself', nil, nil)
  elseif eventName == 'change_slot' then
    --"change_slot", playerID, slotID, prevSide

    local _master_type, _master_slot, _sub_slot = ServerData.GetMulticrewAllParameters(arg1)
    if _sub_slot == nil then
      _sub_slot = ''
    else
      _sub_slot = ' (' .. _sub_slot .. ')  '
    end
    ServerData.LogEvent(eventName, ServerData.SideID2Name(net.get_player_info(arg1, 'side')) .. ' player ' .. net.get_player_info(arg1, 'name') .. ' changed slot to ' .. _master_type .. ' ' .. _sub_slot, nil, nil)

    ServerData.LogStats(arg1)
    ServerData.LogStatsCount(arg1, 'init')
    ServerData.PlayersTableCache['p' .. arg1] = net.get_player_info(arg1)
  elseif eventName == 'connect' then
    --"connect", playerID, name
    ServerData.LogLogin(arg1)
    ServerData.LogEvent(eventName, 'Player ' .. net.get_player_info(arg1, 'name') .. ' connected', nil, nil)
    ServerData.PlayersTableCache['p' .. arg1] = net.get_player_info(arg1)
  elseif eventName == 'disconnect' then
    --"disconnect", playerID, name, playerSide, reason_code
    ServerData.LogEvent(eventName, 'Player ' .. arg2 .. ' disconnected (' .. arg4 .. ').', arg4, nil)
    ServerData.LogStats(arg1)
  elseif eventName == 'crash' then
    --"crash", playerID, unit_missionID
    ServerData.LogStatsCountCrew(arg1, 'crash')
    ServerData.LogEvent(eventName, ServerData.SideID2Name(net.get_player_info(arg1, 'side')) .. ' player(s) ' .. ServerData.GetMulticrewCrewNames(arg1) .. ' crashed in ' .. DCS.getUnitType(arg2), nil, nil)
  elseif eventName == 'eject' then
    --"eject", playerID, unit_missionID
    ServerData.LogStatsCountCrew(arg1, 'eject') -- TBD crew or initiator only?
    ServerData.LogEvent(eventName, ServerData.SideID2Name(net.get_player_info(arg1, 'side')) .. ' player(s) ' .. ServerData.GetMulticrewCrewNames(arg1) .. ' ejected ' .. DCS.getUnitType(arg2), nil, nil)
  elseif eventName == 'takeoff' then
    --"takeoff", playerID, unit_missionID, airdromeName
    if arg3 ~= '' then
      _temp_airfield = ' from ' .. arg3
    end

    ServerData.LogStatsCountCrew(arg1, ServerData.GetTakeOffLandingEvent(true, arg3))
    ServerData.LogEvent(eventName, ServerData.SideID2Name(net.get_player_info(arg1, 'side')) .. ' player(s) ' .. ServerData.GetMulticrewCrewNames(arg1) .. ' took off in ' .. DCS.getUnitType(arg2) .. _temp_airfield, arg3, nil)
  elseif eventName == 'landing' then
    --"landing", playerID, unit_missionID, airdromeName
    if arg3 ~= '' then
      _temp_airfield = ' at ' .. arg3
    end

    ServerData.LogStatsCountCrew(arg1, ServerData.GetTakeOffLandingEvent(false, arg3))
    ServerData.LogEvent(eventName, ServerData.SideID2Name(net.get_player_info(arg1, 'side')) .. ' player(s) ' .. ServerData.GetMulticrewCrewNames(arg1) .. ' landed in ' .. DCS.getUnitType(arg2) .. _temp_airfield, arg3, nil)
  elseif eventName == 'pilot_death' then
    --"pilot_death", playerID, unit_missionID
    ServerData.LogStatsCountCrew(arg1, 'pilot_death') -- TBD crew or initiator only?
    ServerData.LogEvent(eventName, ServerData.SideID2Name(net.get_player_info(arg1, 'side')) .. ' player(s) ' .. ServerData.GetMulticrewCrewNames(arg1) .. ' in ' .. DCS.getUnitType(arg2) .. ' died', nil, nil)
  else
    ServerData.LogEvent(eventName, 'Unknown event type', nil, nil)
  end
  local _delay = (DCS.getRealTime() - _now) * 1000000
  Logger.AddLog('Event handler for ' .. eventName .. ' finished; it took: ' .. _delay .. 'us', 2)
end
