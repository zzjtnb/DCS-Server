ServerData = ServerData or {}
ServerData.net = ServerData.net or {}
ServerData.playList = ServerData.playList or {}
------------------------定义callback-----------------------
ServerData.callbacks = ServerData.callbacks or {}
function ServerData.callbacks.onMissionLoadEnd()
  local data = ServerData.getServerStamp()
  data.mname = DCS.getMissionName()
  data.fname = DCS.getMissionFilename()
  Debugger.net.send_udp_msg({type = "serverData", event = "onMissionLoadEnd", data = data})
end

function ServerData.callbacks.onPlayerTrySendChat(playerID, msg, all)
  if string.find(msg, "qq ") == 1 then
    local data = net.get_player_info(playerID)
    if data ~= nil then
      Debugger.net.send_udp_msg({type = "serverData", event = "updateQQ", data = {qq = msg, ucid = data.ucid}})
      local cmd, err = UDP.udp:receive()
      print("------------接收UDP消息----------------")
      print(cmd)
      print("----------------------------")
      print(err)
      print(err == "timeout")
      if (err == "timeout" or cmd ~= nil) then
        net.send_chat_to("该账号已关联,可以在群进行查询", playerID)
      else
        net.send_chat_to("该账号关联失败!", playerID)
      end
      if err == "closed" then
        net.send_chat_to("数据库已关闭,暂时无法关联!", playerID)
      end
    end
  end
end

function ServerData.callbacks.onGameEvent(eventName, playerID, ...)
  local calls = {}
  local function onGameStub(eventName, ...)
    ServerData.net.log("onGameEvent -> " .. eventName .. ":" .. net.lua2json({playerID = playerID, ...}), true)
  end
  net.log(net.lua2json(arg))
  calls.change_slot = ServerData.change_slot
  calls.connect = ServerData.connect
  calls.disconnect = ServerData.disconnect
  calls.crash = ServerData.crash
  calls.eject = ServerData.eject
  calls.friendly_fire = onGameStub
  calls.kill = ServerData.kill
  calls.landing = ServerData.landing
  calls.mission_end = onGameStub
  calls.pilot_death = ServerData.pilot_death
  calls.self_kill = ServerData.self_kill
  calls.takeoff = ServerData.takeoff
  local call = calls[eventName]
  if call ~= nil then
    if not ServerData.testServer(playerID) then
      call(eventName, ...)
    end
  else
    ServerData.net.log("ERROR: 游戏事件上未注册事件:" .. eventName)
  end
end

DCS.setUserCallbacks(ServerData.callbacks)
