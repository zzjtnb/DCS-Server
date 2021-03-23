ServerData = ServerData or {}
ServerData.net = ServerData.net or {}
ServerData.debug = true
--------------------------------    定义ServerData的方法  --------------------------------
ServerData.isEmptytb = function(tbl)
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
  return {ucid = nil, alias = "SERVER"}
end

--------------------------------    定义ServerData的net  --------------------------------
ServerData.net.log = function(msg, debug)
  if debug == nil then
    if ServerData.debug == true then
      net.log(msg)
    end
  elseif debug == true then
    net.log(msg)
  end
end
