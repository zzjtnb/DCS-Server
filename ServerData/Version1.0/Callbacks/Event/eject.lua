ServerData = ServerData or {}

ServerData.eject = function(eventName, playerID, unit_missionID)
  local data = {
    ucid = net.get_player_info(playerID, "ucid"),
    name = net.get_player_info(playerID, "name"),
    unit_missionID = unit_missionID
  }
  Debugger.net.send_udp_msg({type = "serverData", event = eventName, data = data})
end
