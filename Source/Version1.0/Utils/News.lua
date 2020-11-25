News = {}
function News.admin_caveat(ucid, point, playerID)
  -- if _ucid and SourceObj.playerGroup[_ucid] then
  --   SourceObj.playerSource[_ucid]['point'] = SourceObj.playerSource[_ucid]['point'] - News.point
  --   SourceObj.SaveSourcePoint()
  --   local text = string.format('乱玩管理员指令扣:%d资源点', News.point)
  --   trigger.action.outTextForGroup(SourceObj.playerGroup[_ucid], text, 10)
  -- end
  net.dostring_in("mission", [[a_do_script('SourceObj.lessSourcePoint("]] .. ucid .. '",' .. point .. [[)')]])
  net.send_chat_to("乱玩管理员指令扣100资源点", playerID)
end
