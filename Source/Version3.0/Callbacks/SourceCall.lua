SourceCall = SourceCall or {}
SourceCall.Playinfo = {}

-------------------------------------------------------游戏事件开始--------------------------------------------------
function SourceCall.onPlayerStart(id)
  local _name = net.get_player_info(id, 'name')
  local _ucid = net.get_player_info(id, 'ucid')
  SourceCall.Playinfo[_name] = _ucid
  if DCS.isServer() and DCS.isMultiplayer() and _name and _ucid and id ~= net.get_my_player_id() then
    local status, error = net.dostring_in('mission', "a_do_script('SourceObj.updatePlayerInfo(\"" .. _name .. '", "' .. _ucid .. "\")')")
    if not status then
      net.log('SourceCall.lua -->' .. error)
    end
  end
end
function SourceCall.onPlayerTrySendChat(playerID, msg)
  -- SourceCall.chat_table = SourceCall.chat_table or {}
  -- table.insert(SourceCall.chat_table, {id = playerID, msg = realString, all = all})
  local name = net.get_player_info(playerID, 'name')
  local ucid = net.get_player_info(playerID, 'ucid')
  local realString = Cut_tail_spaces(msg)
  local REXtext = Split_by_space(realString)
  Chatcmd(REXtext, playerID, ucid)
end
function SourceCall.onSimulationFrame()
  if DCS.getModelTime() > 0 then
  end
end
-------------------------------------------------------游戏事件结束--------------------------------------------------
DCS.setUserCallbacks(SourceCall)
