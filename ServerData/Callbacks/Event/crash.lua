ServerData.onEvent.crash = function(eventName, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
  --"crash", playerID, unit_missionID
  ServerData.LogStatsCountCrew(arg1, 'crash')
  -- ServerData.LogEvent(eventName, ServerData.SideID2Name(net.get_player_info(arg1, 'side')) .. ' player(s) ' .. ServerData.GetMulticrewCrewNames(arg1) .. ' crashed in ' .. DCS.getUnitType(arg2), nil, nil)
end
