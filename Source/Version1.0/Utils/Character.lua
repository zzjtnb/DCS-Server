DoString = function(s)
  local f, err = loadstring(s)
  if f then
    return true, f()
  else
    net.log("dostring error in string: " .. err)
    return false
  end
end
--去除尾部空白符
Cut_tail_spaces = function(str)
  local tail = string.find(str, "%s+$") -- find where trailing spaces start
  if tail then
    return string.sub(str, 1, tail - 1) -- cut if there are any
  else
    return str
  end
end
--分割字符串
Split_by_space = function(str)
  local arr = {}
  for w in string.gmatch(str, "%S+") do
    table.insert(arr, w)
  end
  return arr
end
