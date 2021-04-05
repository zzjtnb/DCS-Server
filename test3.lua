local JSON = require('JSON')

local log = {}
local a = {}
a.eventName = 'tackoff'
a.ucid = '5sdfx343'
a.name = '玩家切换座舱'
a.content = '玩家切换座舱'
a.datetime = '2021-4-4'

local b = a
table.insert(log, a)
table.insert(log, b)

print(JSON:encode(log))

function test(data, displayMsg)
  if displayMsg == nil or displayMsg then
    print(data)

    print(displayMsg)
  end
end

test('ddd', true)
