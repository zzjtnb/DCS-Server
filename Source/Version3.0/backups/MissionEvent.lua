local sourceMissionEvent = {}
sourceMissionEvent.eventHandler = {}

SetCategory = {}
-- 联盟
SetCategory.Coalition = {
  [0] = "neutral",
  [1] = "red",
  [2] = "blue"
}
-- 组
SetCategory.Group = {
  [1] = "AIRPLANE",
  [2] = "HELICOPTER",
  [3] = "GROUND",
  [4] = "SHIP"
}
-- 字段
SetCategory.Field = {
  [1] = "Time",
  [2] = "Event",
  [3] = "Initiator ID",
  [4] = "Initiator Coalition",
  [5] = "Initiator Group Category",
  [6] = "Initiator Type",
  [7] = "Initiator Player",
  [8] = "Weapon Category",
  [9] = "Weapon Name",
  [10] = "Target ID",
  [11] = "Target Coalition",
  [12] = "Target Group Category",
  [13] = "Target Type",
  [14] = "Target Player"
}
-- 武器
SetCategory.Weapon = {
  [0] = "SHELL",
  [1] = "MISSILE",
  [2] = "ROCKET",
  [3] = "BOMB"
}
-- 事件
SetCategory.Event = {
  [0] = "S_EVENT_INVALID",
  [1] = "S_EVENT_SHOT",
  [2] = "S_EVENT_HIT",
  [3] = "S_EVENT_TAKEOFF",
  [4] = "S_EVENT_LAND",
  [5] = "S_EVENT_CRASH",
  [6] = "S_EVENT_EJECTION",
  [7] = "S_EVENT_REFUELING",
  [8] = "S_EVENT_DEAD",
  [9] = "S_EVENT_PILOT_DEAD",
  [10] = "S_EVENT_BASE_CAPTURED",
  [11] = "S_EVENT_MISSION_START",
  [12] = "S_EVENT_MISSION_END",
  [13] = "S_EVENT_TOOK_CONTROL",
  [14] = "S_EVENT_REFUELING_STOP",
  [15] = "S_EVENT_BIRTH",
  [16] = "S_EVENT_HUMAN_FAILURE",
  [17] = "S_EVENT_DETAILED_FAILURE",
  [18] = "S_EVENT_ENGINE_STARTUP",
  [19] = "S_EVENT_ENGINE_SHUTDOWN",
  [20] = "S_EVENT_PLAYER_ENTER_UNIT",
  [21] = "S_EVENT_PLAYER_LEAVE_UNIT",
  [22] = "S_EVENT_PLAYER_COMMENT",
  [23] = "S_EVENT_SHOOTING_START",
  [24] = "S_EVENT_SHOOTING_END",
  [25] = "S_EVENT_MARK_ADDED",
  [26] = "S_EVENT_MARK_CHANGE",
  [27] = "S_EVENT_MARK_REMOVED",
  [28] = "S_EVENT_MAX"
}

function sourceMissionEvent.eventHandler:onEvent(event)
  local status, error =
    pcall(
    function(event)
      Initiator = {}
      Target = {}
      WorldEvent = SetCategory.Event[event.id]
      local eWeaponCat = ""
      local eWeaponName = ""
      -- Self world event(DCS World自身事件)
      if WorldEvent == nil then
        WorldEvent = "S_EVENT_UNKNOWN"
      end
      -- Initiator variables(发起者变量)
      if event.initiator then
        if string.sub(event.initiator:getName(), 1, string.len "CARGO") ~= "CARGO" then
          -- safety - hit building or unmanned vehicle(安全 - 击中建筑物或无人驾驶汽车)
          if not event.initiator["getPlayerName"] then
            return
          end
          -- Get initiator player name or AI if NIL(获取发起者玩家名称或AI（如果为NIL）)
          if not event.initiator:getPlayerName() then
            Initiator.Player = "AI"
          else
            Initiator.Player = event.initiator:getPlayerName()
          end
          -- Check Category of object(检查对象类别)
          if not Object.getCategory(event.initiator) then
            -- If no category(如果没有类别)
            Initiator.ID = event.initiator.id_
            Initiator.Coalition = SetCategory.Coalition[event.initiator:getCoalition()]
            Initiator.Category = SetCategory.Group[event.initiator:getCategory()]
            Initiator.TypeName = event.initiator:getTypeName()
          elseif Object.getCategory(event.initiator) == Object.Category.UNIT then
            -- if Category is UNIT(如果类别是UNIT)
            Initiator.Category = event.initiator:getGroup()
            Initiator.ID = event.initiator.id_
            if Initiator.Category:isExist() then
              Initiator.Coalition = SetCategory.Coalition[Initiator.Category:getCoalition()]
              Initiator.Category = SetCategory.Group[Initiator.Category:getCategory() + 1]
            else
              Initiator.Coalition = SetCategory.Coalition[event.initiator:getCoalition()]
              Initiator.Category = SetCategory.Group[event.initiator:getCategory()]
            end
            Initiator.TypeName = event.initiator:getTypeName()
            if event.id == world.event.S_EVENT_BIRTH then
              -- Birth event airborne(空中出生事件)
              if Object.inAir(event.initiator) then
                WorldEvent = "S_EVENT_BIRTH_AIRBORNE"
              end
            end
          elseif Object.getCategory(event.initiator) == Object.Category.STATIC then
            -- if Category is STATIC(如果类别是静态的)
            Initiator.ID = event.initiator.id_
            Initiator.Coalition = SetCategory.Coalition[event.initiator:getCoalition()]
            Initiator.Category = SetCategory.Group[event.initiator:getCategory()]
            Initiator.TypeName = event.initiator:getTypeName()
          end
        elseif not event.initiator then
          Initiator.ID = "No Initiator"
          Initiator.Coalition = "No Initiator"
          Initiator.Category = "No Initiator"
          Initiator.TypeName = "No Initiator"
          Initiator.Player = "No Initiator"
        end
      end
      -- Target variables(目标变量)
      if event.target then
        if string.sub(event.target:getName(), 1, string.len "CARGO") ~= "CARGO" then
          -- safety - hit building or unmanned vehicle(安全 - 击中建筑物或无人驾驶汽车)
          if not event.target["getPlayerName"] then
            return
          end
          -- Get target player name or AI if NIL(获取目标玩家名称或AI（如果为NIL）)
          if not event.target:getPlayerName() then
            -- warnung!
            Target.Player = "AI"
          else
            Target.Player = event.target:getPlayerName()
          end
          -- Check Category of object(检查对象类别)
          -- If no category(如果没有类别)
          if not Object.getCategory(event.target) then
            Target.ID = event.target.id_
            Target.Coalition = SetCategory.Coalition[event.target:getCoalition()]
            Target.TypeName = SetCategory.Group[event.target:getCategory()]
            Target.TypeName = event.target:getTypeName()
          elseif Object.getCategory(event.target) == Object.Category.UNIT then
            -- if Category is UNIT(如果类别是UNIT)
            local TargGroup = event.target:getGroup()
            Target.ID = event.target.id_
            if TargGroup:isExist() then
              Target.Coalition = SetCategory.Coalition[TargGroup:getCoalition()]
              Target.TypeName = SetCategory.Group[TargGroup:getCategory() + 1]
            else
              Target.Coalition = SetCategory.Coalition[event.target:getCoalition()]
              Target.TypeName = SetCategory.Group[event.target:getCategory()]
            end
            Target.TypeName = event.target:getTypeName()
          elseif Object.getCategory(event.target) == Object.Category.STATIC then
            -- if Category is STATIC(如果类别是静态的)
            Target.ID = event.target.id_
            Target.Coalition = SetCategory.Coalition[event.target:getCoalition()]
            Target.TypeName = SetCategory.Group[event.target:getCategory()]
            Target.TypeName = event.target:getTypeName()
          end
        elseif not event.target then
          Target.ID = "No target"
          Target.Coalition = "No target"
          Target.TypeName = "No target"
          Target.TypeName = "No target"
          Target.Player = "No target"
        end
      end

      -- Weapon variables(武器变量)
      -- if event.weapon == nil then
      --   eWeaponCat = "No Weapon"
      --   eWeaponName = "No Weapon"
      -- else
      --   env.info("武器:" .. SourceObj.JSON:encode(event))
      --   local eWeaponDesc = event.weapon:getDesc()
      --   eWeaponCat = SetCategory.Weapon[eWeaponDesc.category]
      --   eWeaponName = eWeaponDesc.displayName
      -- end
      -- write events to table(将事件写入表)
      if event.id == world.event.S_EVENT_SHOT then
        env.info(event.weapon:getDesc())
      end
      if
        event.id == world.event.S_EVENT_HIT or event.id == world.event.S_EVENT_SHOT or event.id == world.event.S_EVENT_EJECTION or event.id == world.event.S_EVENT_CRASH or event.id == world.event.S_EVENT_BIRTH or event.id == world.event.S_EVENT_DEAD or event.id == world.event.S_EVENT_PILOT_DEAD or event.id == world.event.S_EVENT_LAND or event.id == world.event.S_EVENT_MISSION_START or event.id == world.event.S_EVENT_MISSION_END or event.id == world.event.S_EVENT_PLAYER_LEAVE_UNIT or
          event.id == world.event.S_EVENT_TAKEOFF
       then
        local sendstr =
          string.format(
          "时间:%s,事件:%s,攻击者ID:%s,攻击者阵营:%s,攻击者单位类型:%s,攻击者单位名称:%s,攻击者名字:%s,武器类型:%s,武器名称:%s,受害者ID:%s,受害者阵营:%s,受害者单位类型:%s,受害者单位名称:%s,受害者名字:%s",
          math.floor(timer.getTime()),
          WorldEvent,
          tostring(Initiator.ID),
          tostring(Initiator.Coalition),
          tostring(Initiator.Category),
          tostring(Initiator.TypeName),
          tostring(Initiator.Player),
          tostring(eWeaponCat),
          tostring(eWeaponName),
          tostring(Target.ID),
          tostring(Target.Coalition),
          tostring(Target.Category),
          tostring(Target.TypeName),
          tostring(Target.Player)
        )
      -- env.info(sendstr)
      -- local UDP_IP = "127.0.0.1"
      -- local UDP_PORT = "9182"
      -- packag_event.path = packag_event.path .. ";.\\LuaSocket\\?.lua" .. ";.\\Scripts\\?.lua"
      -- packag_event.cpath = packag_event.cpath .. ";.\\LuaSocket\\?.dll"
      -- local socket = require "socket"
      -- local udp = socket.udp()
      -- udp:settimeout(0)
      -- udp:setpeername(UDP_IP, UDP_PORT)
      -- udp:send(sendstr)
      end
    end,
    event
  )
  if (not status) then
    env.error(string.format("资源系统任务事件处理时出错:%s", error), false)
  end
end

world.addEventHandler(sourceMissionEvent.eventHandler)

env.info("资源系统任务事件监听已添加")
