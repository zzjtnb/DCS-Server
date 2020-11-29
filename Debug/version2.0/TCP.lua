if TCP == nil then
  net.log("正在加TCP.lua ...")
  TCP = {}
  TCP.host = "localhost"
  TCP.port = "20200"
  --------------------------------    定义TCP的callbacks  --------------------------------
  local socket = require("socket")
  TCP.server = socket.tcp()
  assert(TCP.server:bind(TCP.host, TCP.port))
  assert(TCP.server:listen()) --转为服务器
  TCP.server:settimeout(1) -- 设置超时时间
  TCP.server:setoption("reuseaddr", true) --重用地址
  TCP.server:setoption("tcp-nodelay", true) -- 设置即时传输模式
  net.log("TCP.lua加载完毕")
end
