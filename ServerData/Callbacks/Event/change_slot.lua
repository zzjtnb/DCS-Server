ServerData.onEvent.change_slot = function(eventName, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
  --"change_slot", playerID, slotID, prevSide
  -- local _master_type, _master_slot, _sub_slot = ServerData.GetMulticrewAllParameters(arg1)
  ServerData.LogStatsCount(arg1, 'init')
  ServerData.PlayersTableCache['p' .. arg1] = net.get_player_info(arg1)
end
