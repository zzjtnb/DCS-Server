do
  SourceCall = SourceCall or {}
  SourceCall.load_admins = function()
    local Admins_f = io.open(SourceCall.Config_Dir .. 'serverAdmins.lua', 'r')
    if Admins_f then
      local Admins_s = Admins_f:read('*all')
      Admins_f:close()
      local Admins_func, err1 = loadstring(Admins_s)
      if Admins_func then
        local safe_env = {}
        setfenv(Admins_func, safe_env)
        local bool, err2 = pcall(Admins_func)
        if not bool then
          env.error('无法加载服务器管理员列表, 原因: ' .. tostring(err2))
          SourceCall.Admins = SourceCall.Admins or {}
        else
          SourceCall.Admins = safe_env['Admins'] or {}
          if safe_env['Admins'] then
            env.info('正在使用定义的管理员 ' .. SourceCall.Config_Dir .. 'ServerAdmins.lua')
          end
        end
      else
        env.error('无法加载服务器管理员列表, 原因: ' .. tostring(err1))
      end
    else
      env.info('未找到或无法打开' .. SourceCall.Config_Dir .. 'ServerAdmins.lua,正在创建文件...')
      SourceCall.Admins = SourceCall.Admins or {}
      SourceCall.update_admins() -- creates the file.
    end
  end

  SourceCall.update_admins = function(client_info)
    SourceCall.Admins = SourceCall.Admins or {}
    if client_info then
      SourceCall.Admins[client_info.ucid] = client_info.name
    end
    local file_s = Serialize('Admins', SourceCall.Admins)
    local Admins_f = io.open(SourceCall.Config_Dir .. 'ServerAdmins.lua', 'w')
    if Admins_f then
      Admins_f:write(file_s)
      Admins_f:close()
      Admins_f = nil
      return '成功', 'sdf'
    else
      env.error('无法打开或写入' .. SourceCall.Config_Dir .. 'ServerAdmins.lua.')
    end
  end
  SourceCall.load_admins()
end
