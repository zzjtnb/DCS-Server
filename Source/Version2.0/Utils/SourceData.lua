SourceObj = SourceObj or {}

function SourceObj.creatDir(path, name)
  lfs.mkdir(path .. name)
  return lfs.writedir() .. name
end
SourceObj.SourceObj_Dir = SourceObj.creatDir(lfs.writedir(), 'SourceData')
function SourceObj.creatFile(path, name, data)
  local FilePath = path .. '\\' .. name
  local LogFile = io.open(FilePath, 'a')
  if LogFile then
    LogFile:write(data .. '\n')
    LogFile:close()
  end
end
function SourceObj.WeaponInfo(data)
  SourceObj.creatFile(SourceObj.SourceObj_Dir, 'WeaponInfo.txt', data)
end
function SourceObj.WeaponData(data)
  SourceObj.creatFile(SourceObj.SourceObj_Dir, 'WeaponData.txt', data)
end
function SourceObj.SourceSavePoint(data)
  SourceObj.creatFile(SourceObj.SourceObj_Dir, 'SourceSavePoint.json', data)
end

--------------------------------------------------------------------加载保存的资源点-----------------------------------------------
SourceObj.SourceSavePointDataPath = SourceObj.SourceObj_Dir .. [[\SourceSavePoint.json]]
SourceObj.SaveSourcePoint = function()
  File = io.open(SourceObj.SourceSavePointDataPath, 'w')
  File:write(SourceObj.JSON:encode(SourceObj.playerSource))
  File:close()
end
SourceObj.LoadSavedSourcePoint = function(path)
  local LoadSourcePoint, error = io.open(path, 'r')
  if LoadSourcePoint then
    local content = LoadSourcePoint:read('*all')
    LoadSourcePoint:close()
    if content then
      if next(SourceObj.JSON:decode(content)) == nil then
        net.log('不存在任何玩家的资源点信息')
      else
        SourceObj.playerSource = SourceObj.JSON:decode(content)
        net.log('读取保存的玩家资源点信息成功')
      end
    end
  else
    net.log('读取保存的资源点失败:' .. error)
    SourceObj.SourceSavePoint('{}')
  end
end
SourceObj.LoadSavedSourcePoint(SourceObj.SourceSavePointDataPath)
