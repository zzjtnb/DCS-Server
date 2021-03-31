ServerData.onEvent.kill = function(eventName, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
  --"kill", killerPlayerID, killerUnitType, killerSide, victimPlayerID, victimUnitType, victimSide, weaponName
  local _temp_victims = ''
  local _temp_killers = ' AI '
  local _temp_event_type = ''
  local _temp_category = ''

  if net.get_player_info(arg4, 'name') ~= nil then
    _temp_victims = ' player(s) ' .. ServerData.GetMulticrewCrewNames(arg4) .. ' '
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
  -- ServerData.LogEvent(eventName, ServerData.SideID2Name(arg3) .. _temp_killers .. ' in ' .. arg2 .. ' killed ' .. ServerData.SideID2Name(arg6) .. _temp_victims .. ' in ' .. victim_vehicle .. ' using ' .. arg7 .. ' [' .. ServerData.GetCategory(arg5) .. ']', arg7, ServerData.GetCategory(arg5))
end

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
