--------------------------------    定义ServerData的方法  --------------------------------
---检测是不是空表
---@param tbl any
---@return boolean 空返回true,反之为false
ServerData.isEmptytb = function(tbl)
  -- Make next function local - this improves performance
  -- 将next函数设为本地-这样可以提高性能
  local next = next
  return next(tbl) == nil
end
ServerData.getPlayerID = function(data)
  data.playerID = data.id
  data.id = nil
  return data
end

ServerData.testServer = function(id)
  return id == net.get_server_id()
end
ServerData.getServerStamp = function()
  return {ucid = nil, alias = 'SERVER'}
end
ServerData.client_send_msg = function(event, data)
  if data ~= nil then
    local result = {
      type = 'ServerData',
      event = event,
      data = data,
      executionTime = {
        dcs_current_frame_delay = ((DCS.getRealTime() - ServerData.lastFrameStart) * 1000000)
      }
    }
    Tools.net.client_send_msg(result)
  end
end
