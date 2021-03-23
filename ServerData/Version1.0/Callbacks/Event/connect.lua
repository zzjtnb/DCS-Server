ServerData = ServerData or {}
ServerData.connect = function(eventName, id)
  if ServerData.testServer(id) then
    return
  end
  local data = net.get_player_info(id)
  if data == nil then
    return
  end
  data = ServerData.getPlayerID(data)
  Debugger.net.send_udp_msg({type = "serverData", event = eventName, data = data})
end
