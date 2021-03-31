ServerData.onEvent.landing = function(eventName, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
  --"landing", playerID, unit_missionID, airdromeName
  local _temp_airfield = ''

  if arg3 ~= '' then
    _temp_airfield = ' at ' .. arg3
  end

  ServerData.LogStatsCountCrew(arg1, ServerData.GetTakeOffLandingEvent(false, arg3))
  -- ServerData.LogEvent(eventName, ServerData.SideID2Name(net.get_player_info(arg1, 'side')) .. ' player(s) ' .. ServerData.GetMulticrewCrewNames(arg1) .. ' landed in ' .. DCS.getUnitType(arg2) .. _temp_airfield, arg3, nil)
end
