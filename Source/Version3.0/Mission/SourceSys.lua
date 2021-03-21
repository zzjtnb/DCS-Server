SourceObj = SourceObj or {}
SourceObj.playerGroup = {}
SourceObj.addedF10Menu = {}
SourceObj.playerUcidByGroup = {}
SourceObj.killEnemy = 100
SourceObj.killFriend = -200
SourceObj.updateSourcePointsByEvent = function(_unit, _ucid, _event)
  SourceObj.playerSource[_ucid] = SourceObj.playerSource[_ucid] or {}
  if SourceObj.playerSource[_ucid]["point"] == nil then
    SourceObj.playerSource[_ucid]["point"] = SourceObj.sourceInitPoint
    SourceObj.SaveSourcePoint()
  end
  if _event == "takeoff" then
    -- local _unitType = _unit:getTypeName()
    local _groupId = SourceObj.getGroupId(_unit)
    local sourcePointChange, countInfo = SourceObj.getSourceObjChange(_unit)

    if SourceObj.playerSource[_ucid]["point"] - sourcePointChange > 0 then
      SourceObj.playerSource[_ucid]["point"] = SourceObj.playerSource[_ucid]["point"] - sourcePointChange
      SourceObj.SaveSourcePoint()
      local text = string.format("起飞成功,本次消耗私有资源点:%d,个人剩余:%d点.\n详细信息:%s", tostring(sourcePointChange), tostring(SourceObj.playerSource[_ucid]["point"]), tostring(countInfo))
      trigger.action.outTextForGroup(_groupId, text, 20, true)
    else
      local text = string.format("你的私有资源点剩余(%d),挂载需要:%d,马上就爆炸了~BOOM", SourceObj.playerSource[_ucid]["point"], sourcePointChange)
      trigger.action.outTextForGroup(_groupId, text, 30, true)
      timer.scheduleFunction(SourceObj.unitExplosion, _unit, timer.getTime() + 10)
    end
  elseif _event == "landing" then
    -- SourceObj.eventAddPoint('降落成功', 30, _ucid, _groupId)
    local _groupId = SourceObj.getGroupId(_unit)
    local sourcePointChange, countInfo = SourceObj.getSourceObjChange(_unit)
    SourceObj.playerSource[_ucid]["point"] = SourceObj.playerSource[_ucid]["point"] + sourcePointChange
    SourceObj.SaveSourcePoint()
    local text = string.format("降落成功,返还私有资源点:%d,个人剩余:%d点.\n详细信息:%s", tostring(sourcePointChange), tostring(SourceObj.playerSource[_ucid]["point"]), tostring(countInfo))
    trigger.action.outTextForGroup(_groupId, text, 10)
  elseif _event == "kill" then
    local _groupId = SourceObj.getGroupId(_unit.initiator)
    if _unit.initiator:getCoalition() ~= _unit.target:getCoalition() then
      SourceObj.eventAddPoint("击杀敌军", SourceObj.getSourceKillChange(_unit.target), _ucid, _groupId)
    else
      SourceObj.eventAddPoint("击杀友军:", -SourceObj.getSourceKillChange(_unit.target), _ucid, _groupId)
    end
  end
end
SourceObj.eventAddPoint = function(_event, _point, _ucid, _groupId)
  local sourcePointsTemp = SourceObj.playerSource[_ucid]["point"]
  SourceObj.playerSource[_ucid]["point"] = sourcePointsTemp + _point
  local text = ""
  if _point > 0 then
    text = string.format("%s,奖励:%s点,你的私有资源点剩余:%d点", _event, tostring(_point), tostring(SourceObj.playerSource[_ucid]["point"]))
  else
    text = string.format("%s,惩罚:%s点,你的私有资源点剩余:%d点", _event, tostring(_point), tostring(SourceObj.playerSource[_ucid]["point"]))
  end
  trigger.action.outTextForGroup(_groupId, text, 10)
end

SourceObj.onBirth = function(_unit)
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
  local _name = _unit:getPlayerName()
  if _name == nil then
    return
  end
  local _ucid = SourceObj.playerInfo[_name]
  if _ucid == nil then
    return
  end
  local _groupId = SourceObj.getGroupId(_unit)
  if _groupId == nil then
    return
  end
  SourceObj.playerGroup[_ucid] = _groupId
  SourceObj.playerUcidByGroup[_groupId] = _ucid
  SourceObj.addF10SourceMenu(_groupId)
  timer.scheduleFunction(SourceObj.initMessage, {_groupId, SourceObj.playerSource[_ucid]["point"]}, timer.getTime() + 15)
end
SourceObj.initMessage = function(_args)
  trigger.action.outTextForGroup(_args[1], "目前F14能携带6枚54A_MK47,但是不能携带54A-MK60和54C-MK47", 60, true)
  --trigger.action.outTextForGroup(_args[1], "警告!由于目前AIM-54有严重的bug, 因此每个架次的F-14B被限制为只能携带2枚AIM-54A_MK47", 60, true)
  local message =
    "*请注意！！！服务器已启用资源系统！请务必详阅以下内容，避免起飞自爆：你当前私有点数:" ..
    tostring(_args[2]) .. -- '\n[1]玩家初始拥有' ..
      -- tostring(_args[2]) ..
      '\n[1]服务器永久保存每位玩家的剩余资源点数,可通过F10菜单查询;\n[2]飞机、弹药、吊舱等都需消耗部分资源点,起飞后合计扣除.返场降落将根据你的弹药余量返点;\n[3]击杀敌方单位、吊运、救援，值班GCI、ATC、OP都可获取相应点数;\n[4]起飞前请务必检查"余额"及挂载量、合理支配点数，如果资源点不足以支付消耗，强行起飞将会自爆;\n[5]资源点明细见NP群:511466821或B站账号:\'NPServer\'\n\n***新机制加入难免BUG,有问题请向NP群管理反映,感谢支持和理解***'
  trigger.action.outTextForGroup(_args[1], message, 60)
end
SourceObj.addF10SourceMenu = function(groupId)
  if not SourceObj.addedF10Menu[groupId] then
    local status, err =
      pcall(
      function()
        local _rootPath = missionCommands.addSubMenuForGroup(groupId, "私有资源点")
        missionCommands.addCommandForGroup(groupId, "查询私有点数", _rootPath, SourceObj.getPointByGroupID, groupId)
      end
    )
    if (not status) then
      env.info("添加资源系统菜单时出错: %s", err)
    end
    SourceObj.addedF10Menu[groupId] = true
  end
end

SourceObj.getPointByGroupID = function(groupId)
  if groupId ~= nil then
    local _ucid = SourceObj.playerUcidByGroup[groupId]
    if _ucid then
      trigger.action.outTextForGroup(groupId, string.format("你的私有资源点剩余:%s", tostring(SourceObj.playerSource[_ucid]["point"])), 30)
    end
  end
end
env.info("资源系统事件处理加载完毕")
