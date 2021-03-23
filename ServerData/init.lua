local loadVersion = "Version1.0"
net.log("INFO: serverData-->开始加载...")
dofile(lfs.writedir() .. "Scripts/ServerData/" .. loadVersion .. "/common.lua")
dofile(lfs.writedir() .. "Scripts/ServerData/" .. loadVersion .. "/Callbacks/init.lua")
net.log("INFO: serverData-->全部加载完毕...")
