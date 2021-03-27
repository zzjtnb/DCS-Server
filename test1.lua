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
