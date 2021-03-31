ServerData.onEvent.eject = function(eventName, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
  --"eject", playerID, unit_missionID
  ServerData.LogStatsCountCrew(arg1, 'eject') -- TBD crew or initiator only?
end
