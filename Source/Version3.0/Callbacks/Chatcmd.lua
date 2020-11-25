Is_include = function(value, tab)
  if tab then
    for k, v in pairs(tab) do
      net.log(k, v)
      if v == value then
        return k
      end
    end
  end
  return false
end

Chatcmd = function(REXtext, playerID, ucid)
  if REXtext[1] == "-admin" and REXtext[2] == "help" or REXtext[2] == "h" then
    if playerID == 1 or SourceCall.Admins[ucid] then
      local text = string.format("管理员命令\n                               1.增加管理员\n  -admin addAdmin name\n                    2.删除管理员\n  -admin removeAdmin name\n              3.给玩家增加资源点\n  -admin addPoint name point\n   4.给玩家减少资源点\n  -admin lessPoint name point")
      net.send_chat_to(text, playerID)
    else
      News.admin_caveat(ucid, 100, playerID)
    end
  elseif REXtext[1] == "-admin" and REXtext[2] == "addAdmin" and REXtext[3] then
    if playerID == 1 or SourceCall.Admins[ucid] then
      if SourceCall.Playinfo[REXtext[3]] then
        SourceCall.add_admins({name = REXtext[3], ucid = SourceCall.Playinfo[REXtext[3]]}, playerID)
      else
        net.send_chat_to("未找到该用户名相关的玩家", playerID)
      end
    else
      News.admin_caveat(ucid, 100, playerID)
    end
  elseif REXtext[1] == "-admin" and REXtext[2] == "removeAdmin" and REXtext[3] then
    if playerID == 1 or SourceCall.Admins[ucid] then
      local id = Is_include(REXtext[3], SourceCall.Admins)
      if id then
        SourceCall.less_admins({name = REXtext[3], ucid = id}, playerID)
      else
        net.send_chat_to("未找到该用户名相关的玩家", playerID)
      end
    else
      News.admin_caveat(ucid, 100, playerID)
    end
  elseif REXtext[1] == "-admin" and REXtext[2] == "addPoint" and REXtext[3] and REXtext[4] then
    if playerID == 1 or SourceCall.Admins[ucid] then
      -- -admin addPoint Admin 1000
      if SourceCall.Playinfo[REXtext[3]] then
        local fun_str = [[a_do_script('SourceObj.addSourcePoint("]] .. SourceCall.Playinfo[REXtext[3]] .. '",' .. REXtext[4] .. [[)')]]
        net.dostring_in("mission", fun_str)
        net.send_chat_to(string.format("%s资源点已增加%d点", REXtext[3], REXtext[4]), playerID)
      else
        net.send_chat_to("未找到该用户名相关的玩家", playerID)
      end
    else
      News.admin_caveat(ucid, 100, playerID)
    end
  elseif REXtext[1] == "-admin" and REXtext[2] == "lessPoint" and REXtext[3] and REXtext[4] then
    if playerID == 1 or SourceCall.Admins[ucid] then
      if SourceCall.Playinfo[REXtext[3]] then
        local fun_str = [[a_do_script('SourceObj.lessSourcePoint("]] .. SourceCall.Playinfo[REXtext[3]] .. '",' .. REXtext[4] .. [[)')]]
        net.dostring_in("mission", fun_str)
        net.send_chat_to(string.format("%s资源点已减少%d点", REXtext[3], REXtext[4]), playerID)
      else
        net.send_chat_to("未找到该用户名相关的玩家", playerID)
      end
    else
      News.admin_caveat(ucid, 100, playerID)
    end
  end
end
