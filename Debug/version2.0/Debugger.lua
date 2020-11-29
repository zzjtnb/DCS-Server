net.log("正在加载Debugger.lua ...")
Debugger = Debugger or {}
--------------------------------    定义Debugger的callbacks  --------------------------------
Debugger.callbacks = {}
function Debugger.callbacks.onMissionLoadBegin()
  Debugger.net.sendMsg({type = "serverStatus", data = {msg = "开始加载任务..."}})
end
function Debugger.callbacks.onMissionLoadEnd()
  Debugger.mission_start_time = DCS.getRealTime() --需要防止CTD引起的C Lua的API上net.pause和net.resume
  Debugger.net.sendMsg({type = "serverStatus", data = {msg = "任务加载结束..."}})
end
function Debugger.callbacks.onSimulationStart()
  if DCS.getRealTime() > 0 then
    Debugger.net.sendMsg({type = "serverStatus", data = {msg = "游戏界面开始运行,可以开始调试Lua脚本"}})
  end
end
function Debugger.callbacks.onSimulationStop()
  Debugger.net.sendMsg({type = "serverStatus", data = {msg = "游戏界面已停止"}})
end
function Debugger.callbacks.onSimulationFrame()
  if Debugger.mission_start_time then
    if DCS.getRealTime() > Debugger.mission_start_time + 8 then
      if TCP.server then
        TCP.client = TCP.server:accept() --等待任何客户端的连接
        if DCS.isServer() and TCP.client then
          TCP.client:settimeout(10) --确保我们不会阻止等待这个客户端消息
          -- local ip, port = TCP.server:getsockname() --获取连接信息
          local line, err = TCP.client:receive() --接收客户端传来的消息
          if not err then
            Debugger.debuggerLua(line)
          end
          TCP.client:close() --与客户端完成后，关闭对象
          return
        end
      end
    end
  end
end
DCS.setUserCallbacks(Debugger.callbacks)
net.log("Debugger.lua加载完毕")
