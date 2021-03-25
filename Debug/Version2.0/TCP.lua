if TCP == nil then
  net.log("正在加TCP.lua ...")
  TCP = {}
  TCP.host = "localhost"
  TCP.port = "20200"

  --------------------------------    定义TCP的callbacks  --------------------------------

  -- log("Starting DCS API CONTROL server")

  -- server = assert(socket.bind("127.0.0.1", PORT))
  -- server:settimeout(0.001)
  -- local ip, port = server:getsockname()
  -- net.log("DCS API Server: Started on Port " .. port .. " at " .. ip)

  local socket = require("socket")
  TCP.server = socket.tcp()
  assert(TCP.server:bind(TCP.host, TCP.port))
  assert(TCP.server:listen()) --转为服务器
  -- TCP.server:settimeout(0.001) --设置超时时间 give up if no connection
  -- TCP.server:setoption("reuseaddr", true) --重用地址
  -- TCP.server:setoption("tcp-nodelay", true) -- 设置即时传输模式
  TCP.client = TCP.server:accept() --等待任何客户端的连接  accept client
  -- TCP.client:settimeout(0.001) --确保我们不会阻止等待这个客户端消息
  net.log("TCP.lua加载完毕")
end
