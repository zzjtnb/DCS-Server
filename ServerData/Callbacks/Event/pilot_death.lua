ServerData.onEvent.pilot_death = function(eventName, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
  --"pilot_death", playerID, unit_missionID
  ServerData.LogStatsCountCrew(arg1, 'pilot_death') -- TBD crew or initiator only?
  -- ServerData.LogEvent(eventName, ServerData.SideID2Name(net.get_player_info(arg1, 'side')) .. ' player(s) ' .. ServerData.GetMulticrewCrewNames(arg1) .. ' in ' .. DCS.getUnitType(arg2) .. ' died', nil, nil)
end
