ArgsMergeTables = function(args, ...)
  local tabs = {...}
  if not tabs then
    return {}
  end
  local origin = tabs[1]
  for i = 2, #tabs do
    if origin then
      if tabs[i] then
        for k, v in pairs(tabs[i]) do
          if tabs[i][args] == origin[args] then
            origin[k] = v
          end
        end
      end
    else
      origin = tabs[i]
    end
  end
  return origin
end

local JSON = require('JSON')
local res = {}
local res2 = {}

local _TempData1 = {}
_TempData1['name'] = 'ddd'
_TempData1['ucid'] = '15551'
_TempData1['loginTime'] = os.date('%Y-%m-%d %H:%M:%S')

local common = {}
common['kills_other'] = 0
common['airfield_takeoffs'] = 0
common['ucid'] = '15551'
common['loginTime'] = os.date('%Y-%m-%d %H:%M:%S')

local _TempData2 = {}
_TempData2['name'] = 'aaa'
_TempData2['ucid'] = '3242'

local ucid = '05234122dsfsd56'
res[ucid] = _TempData1
res[ucid] = ArgsMergeTables('ucid', _TempData1, common)
res['aaa'] = _TempData2
print(JSON:encode(res))

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
