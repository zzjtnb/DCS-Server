-- 变量初始化(Variable init)
ServerData = ServerData or {}
ServerData.lastTimer = 0
ServerData.Version = '3.0'
ServerData.MissionHash = ''
ServerData.lastFrameTime = 0
ServerData.lastSentStatus = 0
ServerData.lastFrameStart = 0
ServerData.net = ServerData.net or {}
ServerData.playList = ServerData.playList or {}
ServerData.StatData = ServerData.StatData or {}
ServerData.callbacks = ServerData.callbacks or {}
ServerData.SlotsData = ServerData.SlotsData or {}
ServerData.StatusData = ServerData.StatusData or {}
ServerData.MissionData = ServerData.MissionData or {}
ServerData.StatDataLastType = ServerData.StatDataLastTyp or {}
-- 连接(Connection)
-- (int) [default: 3600] Base refresh rate in seconds to send status update
-- (int) [默认值: 3600] 发送状态更新的基本刷新率(秒)
ServerData.RefreshStatus = 3600
-- 任务配置(Mission Configuration)
-- (int) [default: 300] Number of secounds after mission start when death of the pilot will not go to statistics, shall avoid death penalty during spawning DCS bugs
---(int)[默认值：300]任务开始后的秒数内当飞行员的死亡不会去统计,避免在DCS产生错误时造成死亡
ServerData.MissionStartNoDeathWindow = 300
-- 本地化(Localisation)
-- (string) Message send to players connecting the server - Line 1
ServerData.MOTD_L1 = 'Welcome to our server ! '
-- ServerData 与 DCS World集成统计和事件数据
-- (string) Message send to players connecting the server - Line 2
-- (string) 消息发送给连接服务器的玩家
ServerData.MOTD_L2 = 'Stats and event data integrated with ServerData for DCS World'
-- (string) Information to send to players when ServerData connection is broken
-- (string) 从服务器数据连接中断时发送给玩家的信息
ServerData.ConnectionError = 'ERROR: Connection broken - contact server admin!'
