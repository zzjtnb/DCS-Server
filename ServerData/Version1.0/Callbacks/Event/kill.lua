ServerData = ServerData or {}

ServerData.kill = function(eventName, killerPlayerID, killerUnitType, killerSide, victimPlayerID, victimUnitType, victimSide, weaponName)
  local kdata = net.get_player_info(killerPlayerID)
  local vdata = net.get_player_info(victimPlayerID)
  if kdata == nil then
    kdata = {}
    kdata.ucid = nil
    kdata.name = "AI"
  end
  if vdata == nil then
    vdata = {}
    vdata.ucid = nil
    vdata.name = "AI"
  end

  local data = {
    ucid = kdata.ucid,
    killerUnitType = killerUnitType,
    killerSide = killerSide,
    victimPlayerID = vdata.ucid,
    victimUnitType = victimUnitType,
    victimSide = victimSide,
    weaponName = weaponName,
    killAlias = kdata.name,
    victimAlias = vdata.name
  }
  Debugger.net.send_udp_msg({type = "serverData", event = eventName, data = data})
end
