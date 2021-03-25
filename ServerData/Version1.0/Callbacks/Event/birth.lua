ServerData = ServerData or {}

ServerData.birth = function(eventName, playerID, unit_missionID, airdromeName)
  local data = {
    ucid = net.get_player_info(playerID, "ucid"),
    name = net.get_player_info(playerID, "name"),
    unit_missionID = unit_missionID,
    airdromeName = airdromeName
  }
  Debugger.net.send_udp_msg({type = "serverData", event = eventName, data = data})
end
