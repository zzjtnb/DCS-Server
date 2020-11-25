-- 防止多个引用（通常错误的脚本安装）
if EventExp == nil then
  -- 联盟
  SetCategory = {}
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
  EventExp = {}

  function EventExp:onEvent(e)
    Initiator = {}
    Target = {}
    local eWeaponCat = ""
    local eWeaponName = ""
    -- Self world event(DCS World自身事件)
    local WorldEvent = SetCategory.Event[e.id]
    if WorldEvent == nil then
      WorldEvent = "S_EVENT_UNKNOWN"
    end
    -- Initiator variables(发起者变量)
    if e.initiator then
      if string.sub(e.initiator:getName(), 1, string.len "CARGO") ~= "CARGO" then
        -- safety - hit building or unmanned vehicle(安全 - 击中建筑物或无人驾驶汽车)
        if not e.initiator["getPlayerName"] then
          return
        end
        -- Get initiator player name or AI if NIL(获取发起者玩家名称或AI（如果为NIL）)
        if not e.initiator:getPlayerName() then
          Initiator.Player = "AI"
        else
          Initiator.Player = e.initiator:getPlayerName()
        end
        -- Check Category of object(检查对象类别)
        if not Object.getCategory(e.initiator) then
          -- If no category(如果没有类别)
          Initiator.ID = e.initiator.id_
          Initiator.Coalition = SetCategory.Coalition[e.initiator:getCoalition()]
          Initiator.Group = SetCategory.Group[e.initiator:getCategory()]
          Initiator.Type = e.initiator:getTypeName()
        elseif Object.getCategory(e.initiator) == Object.Category.UNIT then
          -- if Category is UNIT(如果类别是UNIT)
          Initiator.Group = e.initiator:getGroup()
          Initiator.ID = e.initiator.id_
          if Initiator.Group:isExist() then
            Initiator.Coalition = SetCategory.Coalition[Initiator.Group:getCoalition()]
            Initiator.Group = SetCategory.Group[Initiator.Group:getCategory() + 1]
          else
            Initiator.Coalition = SetCategory.Coalition[e.initiator:getCoalition()]
            Initiator.Group = SetCategory.Group[e.initiator:getCategory()]
          end
          Initiator.Type = e.initiator:getTypeName()
          if e.id == world.event.S_EVENT_BIRTH then
            -- Birth event airborne(空中出生事件)
            if Object.inAir(e.initiator) then
              WorldEvent = "S_EVENT_BIRTH_AIRBORNE"
            end
          end
        elseif Object.getCategory(e.initiator) == Object.Category.STATIC then
          -- if Category is STATIC(如果类别是静态的)
          Initiator.ID = e.initiator.id_
          Initiator.Coalition = SetCategory.Coalition[e.initiator:getCoalition()]
          Initiator.Group = SetCategory.Group[e.initiator:getCategory()]
          Initiator.Type = e.initiator:getTypeName()
        end
      elseif not e.initiator then
        Initiator.ID = "No Initiator"
        Initiator.Coalition = "No Initiator"
        Initiator.Group = "No Initiator"
        Initiator.Type = "No Initiator"
        Initiator.Player = "No Initiator"
      end
    end
    -- Weapon variables(武器变量)
    if e.weapon == nil then
      eWeaponCat = "No Weapon"
      eWeaponName = "No Weapon"
    else
      local eWeaponDesc = e.weapon:getDesc()
      eWeaponCat = SetCategory.Weapon[eWeaponDesc.category]
      eWeaponName = eWeaponDesc.displayName
    end
    -- Target variables(目标变量)
    if e.target then
      if string.sub(e.target:getName(), 1, string.len "CARGO") ~= "CARGO" then
        -- safety - hit building or unmanned vehicle(安全 - 击中建筑物或无人驾驶汽车)
        if not e.target["getPlayerName"] then
          return
        end
        -- Get target player name or AI if NIL(获取目标玩家名称或AI（如果为NIL）)
        if not e.target:getPlayerName() then
          -- warnung!
          Target.Player = "AI"
        else
          Target.Player = e.target:getPlayerName()
        end
        -- Check Category of object(检查对象类别)
        -- If no category(如果没有类别)
        if not Object.getCategory(e.target) then
          Target.ID = e.target.id_
          Target.Coalition = SetCategory.Coalition[e.target:getCoalition()]
          Target.Group = SetCategory.Group[e.target:getCategory()]
          Target.Type = e.target:getTypeName()
        elseif Object.getCategory(e.target) == Object.Category.UNIT then
          -- if Category is UNIT(如果类别是UNIT)
          local TargGroup = e.target:getGroup()
          Target.ID = e.target.id_
          if TargGroup:isExist() then
            Target.Coalition = SetCategory.Coalition[TargGroup:getCoalition()]
            Target.Group = SetCategory.Group[TargGroup:getCategory() + 1]
          else
            Target.Coalition = SetCategory.Coalition[e.target:getCoalition()]
            Target.Group = SetCategory.Group[e.target:getCategory()]
          end
          Target.Type = e.target:getTypeName()
        elseif Object.getCategory(e.target) == Object.Category.STATIC then
          -- if Category is STATIC(如果类别是静态的)
          Target.ID = e.target.id_
          Target.Coalition = SetCategory.Coalition[e.target:getCoalition()]
          Target.Group = SetCategory.Group[e.target:getCategory()]
          Target.Type = e.target:getTypeName()
        end
      elseif not e.target then
        Target.ID = "No target"
        Target.Coalition = "No target"
        Target.Group = "No target"
        Target.Type = "No target"
        Target.Player = "No target"
      end
    end
    -- write events to table(将事件写入表)
    if e.id == world.event.S_EVENT_HIT or e.id == world.event.S_EVENT_SHOT or e.id == world.event.S_EVENT_EJECTION or e.id == world.event.S_EVENT_BIRTH or e.id == world.event.S_EVENT_CRASH or e.id == world.event.S_EVENT_DEAD or e.id == world.event.S_EVENT_PILOT_DEAD or e.id == world.event.S_EVENT_LAND or e.id == world.event.S_EVENT_MISSION_START or e.id == world.event.S_EVENT_MISSION_END or e.id == world.event.S_EVENT_PLAYER_LEAVE_UNIT or e.id == world.event.S_EVENT_TAKEOFF then
      local sendstr = math.floor(timer.getTime()) .. "," .. WorldEvent .. "," .. Initiator.ID .. "," .. Initiator.Coalition .. "," .. Initiator.Group .. "," .. Initiator.Type .. "," .. Initiator.Player .. "," .. eWeaponCat .. "," .. eWeaponName .. "," .. Target.ID .. "," .. Target.Coalition .. "," .. Target.Group .. "," .. Target.Type .. "," .. Target.Player
      env.info(sendstr, true)
    -- local UDP_IP = "127.0.0.1"
    -- local UDP_PORT = "9182"
    -- package.path = package.path .. ";.\\LuaSocket\\?.lua" .. ";.\\Scripts\\?.lua"
    -- package.cpath = package.cpath .. ";.\\LuaSocket\\?.dll"
    -- local socket = require "socket"
    -- local udp = socket.udp()
    -- udp:settimeout(0)
    -- udp:setpeername(UDP_IP, UDP_PORT)
    -- udp:send(sendstr)
    end
  end

  world.addEventHandler(EventExp)
end
