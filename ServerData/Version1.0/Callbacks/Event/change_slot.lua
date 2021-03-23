ServerData = ServerData or {}
ServerData.change_slot = function(eventName, playerID, slotID, prevSide)
  local data = net.get_player_info(playerID)
  data.prevSide = prevSide
  data = ServerData.getPlayerID(data)
  Debugger.net.send_udp_msg({type = "serverData", event = eventName, data = data})
end
