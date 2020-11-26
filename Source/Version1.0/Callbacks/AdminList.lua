do
  SourceCall = SourceCall or {}
  SourceCall.AdminFile = SourceCall.Config_Dir .. "管理员列表.json"
  SourceCall.load_admins = function()
    local Admins_File = io.open(SourceCall.AdminFile, "r")
    if Admins_File then
      local Admins_str = Admins_File:read("*all")
      Admins_File:close()
      local Admins_tb = net.json2lua(Admins_str)
      if Admins_tb then
        SourceCall.Admins = Admins_tb or {}
      end
    else
      net.log("未找到或无法打开" .. SourceCall.AdminFile)
      SourceCall.Admins = SourceCall.Admins or {}
      SourceCall.add_admins() -- creates the file.
    end
  end

  SourceCall.add_admins = function(client_info, playerID)
    SourceCall.Admins = SourceCall.Admins or {}
    if client_info then
      SourceCall.Admins[client_info.ucid] = client_info.name
    end
    local file_str = net.lua2json(SourceCall.Admins)
    local Admins_File = io.open(SourceCall.AdminFile, "w")
    if Admins_File then
      Admins_File:write(file_str)
      Admins_File:close()
      Admins_File = nil
      net.send_chat_to("添加成功", playerID)
    else
      net.send_chat_to("添加失败,请查看日志", playerID)
      net.log("无法打开或写入" .. SourceCall.AdminFile)
    end
  end
  SourceCall.less_admins = function(client_info, playerID)
    if client_info then
      SourceCall.Admins[client_info.ucid] = nil
    end
    local file_str = net.lua2json(SourceCall.Admins)
    local Admins_File = io.open(SourceCall.AdminFile, "w")
    if Admins_File then
      Admins_File:write(file_str)
      Admins_File:close()
      Admins_File = nil
      net.send_chat_to("删除成功", playerID)
    else
      net.send_chat_to("添加失败,请查看日志", playerID)
      net.log("无法打开或写入" .. SourceCall.AdminFile)
    end
  end

  SourceCall.load_admins()
end
