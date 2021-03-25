ServerData = ServerData or {}

ServerData.engine = function(eventName, playerID, unit_missionID, airdromeName)
  net.log("测试engine:" .. eventName)
  local data = {
    ucid = net.get_player_info(playerID, "ucid"),
    name = net.get_player_info(playerID, "name"),
    unit_missionID = unit_missionID,
    airdromeName = airdromeName
  }
  Debugger.net.send_udp_msg({type = "serverData", event = eventName, data = data})
end
