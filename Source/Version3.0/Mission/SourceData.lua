SourceData = {}

function SourceData.creatDir(path, name)
  lfs.mkdir(path .. name)
  return lfs.writedir() .. name
end
SourceData.SourceData_Dir = SourceData.creatDir(lfs.writedir(), "SourceData")
function SourceData.creatFile(path, name, data)
  local FilePath = path .. "\\" .. name
  local LogFile = io.open(FilePath, "a")
  if LogFile then
    LogFile:write(data .. "\n")
    LogFile:close()
  end
end
function SourceData.WeaponInfo(data)
  SourceData.creatFile(SourceData.SourceData_Dir, "WeaponInfo.txt", data)
end
function SourceData.WeaponData(data)
  SourceData.creatFile(SourceData.SourceData_Dir, "WeaponData.txt", data)
end

env.info("资源点获取武器信息已加载")
