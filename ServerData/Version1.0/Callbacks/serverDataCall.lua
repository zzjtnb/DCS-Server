ServerData = ServerData or {}
ServerData.net = ServerData.net or {}
ServerData.playList = ServerData.playList or {}
------------------------定义callback-----------------------
ServerData.callbacks = ServerData.callbacks or {}
function ServerData.callbacks.onMissionLoadEnd()
  local data = ServerData.getServerStamp()
  DCS.getMissionOptions() --返回'mission.options'的值
  data.mname = DCS.getMissionName() --返回当前任务的名称
  data.fname = DCS.getMissionFilename() --返回当前任务的文件名
  data.description = DCS.getMissionDescription() --任务描述
  data.currentMission = DCS.getCurrentMission() --当前任务
  Debugger.net.send_udp_msg({type = "serverData", event = "onMissionLoadEnd", data = data})
  --[[
      --返回阵营可用插槽列表。
      DCS.getAvailableCoalitions()
      --获取指定阵营的可用插槽(注意:返回的unitID实际上是一个slotID,对于多座单位它是
      DCS.getAvailableSlots(coalitionID) 'unitID_seatID')
      --获取单位属性
      DCS.getUnitProperty(missionId, propertyId)
      --从配置状态读取一个值。
      DCS.getConfigValue(cfg_path_string)
      -> {{abstime,级别,子系统,消息},...},last_index 返回从给定索引开始的最新日志消息。
      DCS.getLogHistory(from)
      Usage:
      local result = {}
      local id_from = 0
      local logHistory = {}
      local logIndex = 0
      logHistory, logIndex = DCS.getLogHistory(id_from)
      result = {
        logHistory = logHistory,
        new_last_id = logIndex
      }
      return result

     --log.write('WebGUI', log.DEBUG, string.format('%s returned %s!', requestString, net.lua2json(result)))
  --]]
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

function ServerData.callbacks.onNetMissionEnd()
  Debugger.net.send_udp_msg({type = "serverData", event = "onNetMissionEnd", data = {msg = "网络任务结束时"}})
end
function ServerData.callbacks.onNetDisconnect()
  Debugger.net.send_udp_msg({type = "serverData", event = "onNetDisconnect", data = {msg = "网络断开连接"}})
end
function ServerData.callbacks.onSimulationStop()
  local data = {msg = "游戏界面已停止"}
  data.result_red = DCS.getMissionResult("red")
  data.result_blue = DCS.getMissionResult("blue")
  Debugger.net.send_udp_msg({type = "serverData", event = "onSimulationStop", data = data})
end
DCS.setUserCallbacks(ServerData.callbacks)
