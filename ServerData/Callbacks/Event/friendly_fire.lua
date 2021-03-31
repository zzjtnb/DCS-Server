ServerData.onEvent.friendly_fire = function(eventName, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
  --"friendly_fire", playerID, weaponName, victimPlayerID
  if arg2 == '' then
    arg2 = 'Cannon'
  end
  -- ServerData.LogEvent(eventName, ServerData.SideID2Name(net.get_player_info(arg1, 'side')) .. ' player(s) ' .. ServerData.GetMulticrewCrewNames(arg1) .. ' killed friendly ' .. ServerData.GetMulticrewCrewNames(arg3) .. ' using ' .. arg2, nil, nil)
end
