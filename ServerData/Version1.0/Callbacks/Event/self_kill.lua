ServerData = ServerData or {}

ServerData.self_kill = function(eventName, playerID)
  local data = {
    ucid = net.get_player_info(playerID, "ucid"),
    name = net.get_player_info(playerID, "name")
  }
  Debugger.net.send_udp_msg({type = "serverData", event = eventName, data = data})
end
