SourceObj = SourceObj or {}
SourceObj.net = {}
SourceObj.playList = {}
SourceObj.sourceInit = 1000
SourceObj.playerInfo = {}
SourceObj.playerGroup = {}
SourceObj.playerSource = {}
SourceObj.addedF10Menu = {}
------------------------定义callback-----------------------
SourceObj.callbacks = {}
--DOC
-- onGameEvent(eventName,arg1,arg2,arg3,arg4)
--"friendly_fire", playerID, weaponName, victimPlayerID
--"mission_end", winner, msg
--"kill", killerPlayerID, killerUnitType, killerSide, victimPlayerID, victimUnitType, victimSide, weaponName
--"self_kill", playerID
--"change_slot", playerID, slotID, prevSide
--"connect", id, name
--"disconnect", ID_, name, playerSide
--"crash", playerID, unit_missionID
--"eject", playerID, unit_missionID
--"takeoff", playerID, unit_missionID, airdromeName
--"landing", playerID, unit_missionID, airdromeName
--"pilot_death", playerID, unit_missionID
--
SourceObj.callbacks.onGameEvent = function(eventName, playerID, arg2, arg3, arg4, arg5, arg6, arg7)
  net.log('onGameEvent事件名称: --> ' .. eventName .. ' : ' .. net.lua2json({playerID = playerID, arg2 = arg2, arg3 = arg3, arg4 = arg4, arg5 = arg5, arg6 = arg6, arg7 = arg7}), true)

  local calls = {}
  local function onGameStub(eventName)
    net.log('onGameStub事件名称: --> ' .. eventName)
  end

  calls.change_slot = SourceObj.change_slot
  calls.connect = onGameStub
  calls.crash = SourceObj.crash
  calls.disconnect = onGameStub
  calls.eject = onGameStub
  calls.friendly_fire = onGameStub
  calls.kill = SourceObj.kill
  calls.landing = SourceObj.landing
  calls.mission_end = onGameStub
  calls.pilot_death = SourceObj.pilot_death
  calls.self_kill = SourceObj.self_kill
  calls.takeoff = SourceObj.takeoff
  local call = calls[eventName]
  if call == nil then
    net.log('游戏事件上未注册事件 : ' .. eventName)
  else
    if not SourceObj.checkServer(playerID) then
      call(eventName, playerID, arg2, arg3, arg4, arg5, arg6, arg7)
    end
  end
end
SourceObj.callbacks.onPlayerStart = function(playerID)
  -- SourceObj.playerInfo = net.get_player_info(playerID)
  -- if SourceObj.playerSource[SourceObj.playerInfo['ucid']] == nil then
  --   SourceObj.playerSource[SourceObj.playerInfo['ucid']] = SourceObj.sourceInit
  --   SourceObj.SaveSourcePoint()
  -- end
  -- -- SourceObj.initMessage(playerID, SourceObj.playerSource[SourceObj.playerInfo['ucid']])
  -- net.log('玩家ID:-->' .. DCS.getUnitType(playerID))
end
DCS.setUserCallbacks(SourceObj.callbacks)
net.log('资源系统回调函数已添加')
-------------------------------------------------------自定义方法----------------------------------------------
SourceObj.change_slot = function()
  net.log('change_slot-->玩家改变插槽')
end
SourceObj.kill = function(eventName, killerPlayerID, killerUnitType, killerSide, victimPlayerID, victimUnitType, victimSide, weaponName)
  local kdata = net.get_player_info(killerPlayerID)
  local vdata = net.get_player_info(victimPlayerID)
  if kdata == nil then
    kdata = {}
    kdata.ucid = '00000000000000000000000000000000'
    kdata.name = 'AI'
  end

  if vdata == nil then
    vdata = {}
    vdata.ucid = '00000000000000000000000000000000'
    vdata.name = 'AI'
  end
end
SourceObj.landing = function(eventName, unit_missionID, airdromeName)
  net.log('change_slot-->玩家改变插槽')
end
SourceObj.eventHandler = {}
function SourceObj.eventHandler:onEvent(_event)
  local status, error =
    pcall(
    function(_event)
      if _event == nil or _event.initiator == nil then
        return false
      elseif _event.id == 3 and _event.initiator ~= nil then
        local _unit = _event.initiator
        SourceObj.WeaponInfo(SourceObj.JSON:encode(_unit.getAmmo(_unit)))
        if _unit:getPlayerName() ~= nil then
          local _ucid = SourceObj.playerInfo[_unit:getPlayerName()]
          if _ucid then
            SourceObj.updateSourcePointsByEvent(_unit, _ucid, 'takeoff')
          end
        end
      elseif _event.id == 4 and _event.initiator ~= nil then
        local _unit = _event.initiator
        local _ucid = SourceObj.playerInfo[_unit:getPlayerName()]
        if _ucid and _event.place then
          SourceObj.updateSourcePointsByEvent(_unit, _ucid, 'landing')
        end
      elseif _event.id == 15 and _event.initiator ~= nil then
        -- SourceObj.onBirth(_event.initiator)
        net.log('玩家出生')
        env.info('啊啊哈哈')
      elseif _event.id == 29 and _event.initiator ~= nil and _event.target ~= nil then
        local _initiator = _event.initiator --发起者
        if _initiator:getPlayerName() ~= nil then
          local _ucid = SourceObj.playerInfo[_initiator:getPlayerName()]
          if _ucid ~= nil then
            SourceObj.updateSourcePointsByEvent(_event, _ucid, 'kill')
          end
        end
      else
      end
    end,
    _event
  )
  if (not status) then
    env.error(string.format('资源系统任务事件处理时出错:%s', error), false)
  end
end
local fun = [[world.addEventHandler(SourceObj.eventHandler)]]
net.dostring_in('mission', fun)
