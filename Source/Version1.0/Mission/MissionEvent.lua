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
        -- SourceData.WeaponInfo(SourceObj.JSON:encode(_unit.getAmmo(_unit)))
        if _unit:getPlayerName() ~= nil then
          local _ucid = SourceObj.playerInfo[_unit:getPlayerName()]
          if _ucid then
            SourceObj.updateSourcePointsByEvent(_unit, _ucid, "takeoff")
          end
        end
      elseif _event.id == 4 and _event.initiator ~= nil then
        local _unit = _event.initiator
        local _ucid = SourceObj.playerInfo[_unit:getPlayerName()]
        if _ucid then
          SourceObj.updateSourcePointsByEvent(_unit, _ucid, "landing")
        end
      elseif _event.id == 15 and _event.initiator ~= nil then
        SourceObj.onBirth(_event.initiator)
      elseif _event.id == 28 and _event.initiator ~= nil and _event.target ~= nil then
        local _initiator = _event.initiator --发起者
        if _initiator:getPlayerName() ~= nil then
          local _ucid = SourceObj.playerInfo[_initiator:getPlayerName()]
          if _ucid ~= nil then
            SourceObj.updateSourcePointsByEvent(_event, _ucid, "kill")
          end
        end
      else
      end
      -- if _event.initiator then
      --   local _typeName = _event.initiator:getTypeName()
      --   if _typeName then
      --     if SourceObj.is_include(_typeName, Aircraft.superiorityFighter) or SourceObj.is_include(_typeName, SourceObj.BugFighter) or SourceObj.is_include(_typeName, Aircraft.lightFighter) or SourceObj.is_include(_typeName, Aircraft.attacker) or SourceObj.is_include(_typeName, Aircraft.helicopter) then
      --       local _ucid = SourceObj.playerInfo[_event.initiator:getPlayerName()]
      --       if _ucid then
      --         if _event.initiator:inAir() == false then
      --           env.info('在地上')
      --           SourceObj.realRecoverTime = SourceObj.landRecoverTime - SourceObj.timeHasRun
      --         else
      --           env.info('在天上')
      --           SourceObj.realRecoverTime = SourceObj.skyRecoverTime - SourceObj.timeHasRun
      --         end
      --       end
      --     end
      --   end
      -- end
    end,
    _event
  )
  if (not status) then
    env.error(string.format("资源系统任务事件处理时出错:%s", error), false)
  end
end

world.addEventHandler(sourceMissionEvent.eventHandler)

env.info("资源系统任务事件监听已添加")
