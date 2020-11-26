Utils = {}
function Utils.admin_caveat(ucid, point, playerID)
  net.dostring_in("mission", [[a_do_script('SourceObj.lessSourcePoint("]] .. ucid .. '",' .. point .. [[)')]])
  net.send_chat_to("乱玩管理员指令扣100资源点", playerID)
end
Utils.checkServer = function(id)
  if id == net.get_server_id() then
    return true
  else
    return false
  end
end
Utils.sendMessage = function(GroupID, msg, showTime)
  if GroupID then
    local str = "trigger.action.outTextForGroup(" .. GroupID .. ",'" .. msg .. "'," .. showTime .. "); return true;"
    net.log(str)
    local _status, _error = net.dostring_in("server", str)
    net.log("状态:", _status, _error)
    if not _status and _error then
      net.log("Error! " .. _error)
    end
  else
    local str = "trigger.action.outText('" .. msg .. "'," .. showTime .. ",true); return true;"
    local _status, _error = net.dostring_in("server", str)
    if not _status and _error then
      net.log("Error! " .. _error)
    end
  end
end
