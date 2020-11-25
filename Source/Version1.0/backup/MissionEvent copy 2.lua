local sourceMissionEvent = {}
sourceMissionEvent.eventHandler = {}
function sourceMissionEvent.eventHandler:onEvent(_event)
  local status, error =
    pcall(
    function(_event)
      if _event == nil or _event.initiator == nil then
        return false
      elseif _event.id == 3 and _event.initiator ~= nil then
        local _unit = _event.initiator
        env.info(SourceObj.JSON:encode(_unit.getAmmo(_unit)))
        SourceData.WeaponInfo(SourceObj.JSON:encode(_unit.getAmmo(_unit)))
        if _unit:getPlayerName() ~= nil then
          local _ucid = SourceObj.playerInfo[_unit:getPlayerName()]
          if _ucid then
            SourceObj.updateSourcePointsByEvent(_unit, _ucid, 'takeoff')
          end
        end
      elseif _event.id == 4 and _event.initiator ~= nil then
        local _unit = _event.initiator
        local _ucid = SourceObj.playerInfo[_unit:getPlayerName()]
        if _ucid then
          SourceObj.updateSourcePointsByEvent(_unit, _ucid, 'landing')
        end
      elseif _event.id == 15 and _event.initiator ~= nil then
        SourceObj.onBirth(_event.initiator)
      elseif _event.id == 28 and _event.initiator ~= nil and _event.target ~= nil then
        local _initiator = _event.initiator --发起者
        if _initiator:getPlayerName() ~= nil then
          local _ucid = SourceObj.playerInfo[_initiator:getPlayerName()]
          env.info(_ucid)
          if _ucid ~= nil then
            SourceObj.updateSourcePointsByEvent(_event, _ucid, 'kill')
          end
        end
      else
      end

      if _event.id == 1 or _event.id == 2 or _event.id == 3 or _event.id == 7 or _event.id == 23 or _event.id == 24 or _event.id == 28 then
        if _event.initiator then
          local _ucid = SourceObj.playerInfo[_event.initiator:getPlayerName()]
          SourceObj.realTime = timer.getTime() + SourceObj.skyRecoverTime - SourceObj.realTime
          timer.scheduleFunction(SourceObj.autoAddSourcePoint, _ucid, SourceObj.realTime)
        end
      else
        if _event.initiator then
          local _ucid = SourceObj.playerInfo[_event.initiator:getPlayerName()]
          SourceObj.realTime = timer.getTime() + SourceObj.landRecoverTime - SourceObj.realTime
          timer.scheduleFunction(SourceObj.autoAddSourcePoint, _ucid, SourceObj.realTime)
        end
      end
    end,
    _event
  )
  if (not status) then
    env.error(string.format('资源系统任务事件处理时出错:%s', error), false)
  end
end

world.addEventHandler(sourceMissionEvent.eventHandler)

env.info('资源系统任务事件监听已添加')
