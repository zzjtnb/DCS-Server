SourceObj = SourceObj or {}
SourceObj.addTeamF10Menu = {}
SourceObj.REDPOINT = 0
SourceObj.BLUEPOINT = 0
SourceObj.updateTeamSourcePointsByEvent = function(_unit, _ucid, _event)
  if _event == "takeoff" then
    local _groupId = SourceObj.getGroupId(_unit)
    local sourcePointChange = SourceObj.getSourceObjChange(_unit)
    if SourceObj.playerSource[_ucid]["point"] - sourcePointChange > 0 then
      if _unit:getCoalition() == 1 then
        SourceObj.REDPOINT = SourceObj.REDPOINT - sourcePointChange
        if SourceObj.REDPOINT > 0 then
          local text = string.format("红方阵营点数减少:%d点,当前点数:%d点", tostring(sourcePointChange), tostring(SourceObj.REDPOINT))
          trigger.action.outTextForGroup(_groupId, text, 20)
        else
          trigger.action.outText("红方战败,剩余点数:" .. tostring(SourceObj.REDPOINT), 1000)
        end
      end
      if _unit:getCoalition() == 2 then
        SourceObj.BLUEPOINT = SourceObj.BLUEPOINT - sourcePointChange
        if SourceObj.BLUEPOINT > 0 then
          local text = string.format("蓝方阵营点数减少:%d点,当前点数:%d点", tostring(sourcePointChange), tostring(SourceObj.BLUEPOINT))
          trigger.action.outTextForGroup(_groupId, text, 20)
        else
          trigger.action.outText("蓝方战败,剩余点数:" .. tostring(SourceObj.BLUEPOINT), 1000)
        end
      end
    end
  elseif _event == "landing" then
    local _groupId = SourceObj.getGroupId(_unit)
    local sourcePointChange = SourceObj.getSourceObjChange(_unit)
    if _unit:getCoalition() == 1 then
      SourceObj.REDPOINT = SourceObj.REDPOINT + sourcePointChange
      if SourceObj.REDPOINT > 0 then
        local text = string.format("红方阵营点数减少:%d点,当前点数:%d点", tostring(sourcePointChange), tostring(SourceObj.REDPOINT))
        trigger.action.outTextForGroup(_groupId, text, 20)
      else
        trigger.action.outText("红方战败,剩余点数:" .. tostring(SourceObj.REDPOINT), 1000)
      end
    end
    if _unit:getCoalition() == 2 then
      SourceObj.BLUEPOINT = SourceObj.BLUEPOINT + sourcePointChange
      if SourceObj.BLUEPOINT > 0 then
        local text = string.format("蓝方阵营点数减少:%d点,当前点数:%d点", tostring(sourcePointChange), tostring(SourceObj.BLUEPOINT))
        trigger.action.outTextForGroup(_groupId, text, 20)
      else
        trigger.action.outText("蓝方战败,剩余点数:" .. tostring(SourceObj.BLUEPOINT), 1000)
      end
    end
  end
end
SourceObj.lessSourceTeamPoint = function(team, point)
  env.info(team, tostring(point))
  if team == "RED" then
    SourceObj.REDPOINT = SourceObj.REDPOINT - point
  elseif team == "BLUE" then
    SourceObj.BLUEPOINT = SourceObj.BLUEPOINT - point
  end
end
SourceObj.addSourceTeamPoint = function(team, point)
  env.info(team)
  env.info(tostring(point))
  env.info(tostring(SourceObj.BLUEPOINT))
  if team == "RED" then
    SourceObj.REDPOINT = SourceObj.REDPOINT + point
  elseif team == "BLUE" then
    SourceObj.BLUEPOINT = SourceObj.BLUEPOINT + point
  end
end
SourceObj.onTeamBirth = function(_unit)
  local displayMsg = false
  local _typeName = _unit:getTypeName()
  if _typeName then
    if SourceObj.is_include(_typeName, Aircraft.superiorityFighter) or SourceObj.is_include(_typeName, SourceObj.BugFighter) or SourceObj.is_include(_typeName, Aircraft.lightFighter) or SourceObj.is_include(_typeName, Aircraft.attacker) or SourceObj.is_include(_typeName, Aircraft.helicopter) then
      displayMsg = true
    end
  end
  if not displayMsg then
    return
  end
  local _groupId = SourceObj.getGroupId(_unit)
  if _groupId == nil then
    return
  end
  local _team = _unit:getCoalition()
  SourceObj.addF10TeamSourceMenu(_groupId, _team)
end
SourceObj.addF10TeamSourceMenu = function(groupId, _team)
  if not SourceObj.addTeamF10Menu[groupId] then
    local status, err =
      pcall(
      function()
        local _rootPath = missionCommands.addSubMenuForGroup(groupId, "战役资源系统")
        if _team == 0 then
          missionCommands.addCommandForGroup(groupId, "查询战役资源点", _rootPath, SourceObj.getTeamPoint, groupId)
        end
        if _team == 1 then
          missionCommands.addCommandForGroup(groupId, "查询战役资源点", _rootPath, SourceObj.getRedPoint, groupId)
        end
        if _team == 2 then
          missionCommands.addCommandForGroup(groupId, "查询战役资源点", _rootPath, SourceObj.getBluePoint, groupId)
        end
      end
    )
    if (not status) then
      env.info("添加战役资源系统菜单时出错: %s", err)
    end
    SourceObj.addTeamF10Menu[groupId] = true
  end
end
SourceObj.getTeamPoint = function(groupId)
  if groupId ~= nil then
    local _ucid = SourceObj.playerUcidByGroup[groupId]
    if _ucid then
      trigger.action.outTextForGroup(groupId, string.format("当前拥有战役资源点红方:%s,蓝方:%s", tostring(SourceObj.REDPOINT), tostring(SourceObj.BLUEPOINT)), 30)
    end
  end
end
SourceObj.getRedPoint = function(groupId)
  if groupId ~= nil then
    local _ucid = SourceObj.playerUcidByGroup[groupId]
    if _ucid then
      trigger.action.outTextForGroup(groupId, string.format("当前拥有战役资源点:%s", tostring(SourceObj.REDPOINT)), 30)
    end
  end
end
SourceObj.getBluePoint = function(groupId)
  if groupId ~= nil then
    local _ucid = SourceObj.playerUcidByGroup[groupId]
    if _ucid then
      trigger.action.outTextForGroup(groupId, string.format("当前拥有战役资源点:%s", tostring(SourceObj.BLUEPOINT)), 30)
    end
  end
end
env.info("战役资源系统事件处理加载完毕")
