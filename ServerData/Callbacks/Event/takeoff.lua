ServerData.onEvent.takeoff = function(eventName, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
  --"takeoff", playerID, unit_missionID, airdromeName
  local _temp_airfield = ''
  if arg3 ~= '' then
    _temp_airfield = ' from ' .. arg3
  end
  ServerData.LogStatsCountCrew(arg1, ServerData.GetTakeOffLandingEvent(true, arg3))
  -- ServerData.LogEvent(eventName, ServerData.SideID2Name(net.get_player_info(arg1, 'side')) .. ' player(s) ' .. ServerData.GetMulticrewCrewNames(arg1) .. ' took off in ' .. DCS.getUnitType(arg2) .. _temp_airfield, arg3, nil)
end
