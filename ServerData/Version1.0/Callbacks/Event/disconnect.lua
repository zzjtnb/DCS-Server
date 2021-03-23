ServerData = ServerData or {}
ServerData.disconnect = function(eventName, playerID, name, playerSide, reason_code)
  local data = {
    playerID = playerID,
    name = name,
    side = playerSide,
    err = reason_code
  }
  Debugger.net.send_udp_msg({type = "serverData", event = eventName, data = data})
end
