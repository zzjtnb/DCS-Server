-- print(os.date('%c', '2016-6-21'))

local data = {
  year = 2016,
  day = 21,
  mounth = 6
}

print(os.time {year = 1970, month = 1, day = 1})

-- print(
--   os.time {
--     Year = 2016,
--     Day = 21,
--     Month = 6
--   }
-- )

local JSON = require('JSON')
print(JSON:encode(os.date('%Y-%m-%d', 906000490)))

-- print(package.path)
local JSON = require('JSON')
local res = {}
res.id = {}
res.name = {}
res.getByName = {}
res.getUnits = {}
res.getAmmo = {}
for i, gp in pairs(coalition.getGroups(1)) do
  res.id[i] = Group.getID(gp)
  res.name[i] = Group.getName(gp)
  res.getByName[i] = Group.getByName(res.name[i])
  res.getUnits[i] = gp:getUnits()
  for index, data in pairs(gp:getUnits()) do
    res.getAmmo[index] = Unit.getAmmo(data)
    --data等于gp:getUnits()[index]
    -- env.info('测试:' .. JSON:encode(data)) --测试:{"id_":16777729}
  end
end
return JSON:encode(res)
