local JSON = require('JSON')
local res = {}
local res2 = {}

local ucid = '05234122dsfsd56'

local _TempData1 = {}
_TempData1['kills_other'] = 0
_TempData1['airfield_takeoffs'] = 0

local _TempData2 = {}
_TempData2['name'] = 'ddd'
_TempData2['ucid'] = 'sdfsdf234sdf'
local data = {}
data['gameInfo'] = _TempData1
res2[ucid] = data
table.insert(res, res2)
data['loginInfo'] = _TempData1
-- res2['gameInfo'] = _TempData1
res2[ucid] = data
-- print(JSON:encode(data))
print(JSON:encode(res2))
-- print(JSON:encode(res))
local ucid2 = '23fsf234'
res2[ucid2] = data
print(JSON:encode(res2))

local test = {}
table.insert(test, 'ddd')
table.insert(test, 'ddd')
print(JSON:encode(test))

-- 字典型table
local kvTbl = {id = 123, level = 99, score = 100}
-- dump(kvTbl)  -- {"level" = 99, "score" = 100, "id" = 123} 存储的顺序与table定义时的顺序并不相同
-- 增
kvTbl['rank'] = {datat = 66}
-- dump(kvTbl)  -- {"level" = 99, "score" = 100, "rank" = 66, "id" = 123}
kvTbl.count = 88
-- dump(kvTbl)  -- {"score" = 100, "id" = 123, "count" = 88, "rank" = 66, "level" = 99}
-- 删
kvTbl['score'] = nil
-- dump(kvTbl)  -- {"id" = 123, "rank" = 66, "level" = 99, "count" = 88}
kvTbl.rank = nil
-- dump(kvTbl)  -- {"id" = 123, "level" = 99, "count" = 88}
