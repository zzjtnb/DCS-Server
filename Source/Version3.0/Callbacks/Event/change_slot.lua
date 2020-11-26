SourceCall = SourceCall or {}
SourceCall.change_slot = function(eventName, playerID, slotID, prevSide)
  net.log(SourceCall.JSON:encode(net.get_player_info(playerID)))
  local grroupID = DCS.getUnitProperty(slotID, DCS.UNIT_GROUP_MISSION_ID)
  if grroupID then
    -- Utils.sendMessage(grroupID, "你的groupID:" .. tostring(grroupID), 50)
    SourceCall.PlayerName[grroupID] = grroupID
  end
end
