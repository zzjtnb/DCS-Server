SourceObj = SourceObj or {}
--基本序列化
function SourceObj.basicSerialize(s)
  if s == nil then
    return '""'
  else
    if ((type(s) == "number") or (type(s) == "boolean") or (type(s) == "function") or (type(s) == "table") or (type(s) == "userdata")) then
      return tostring(s)
    elseif type(s) == "string" then
      return string.format("%q", s)
    end
  end
end
--序列化
function SourceObj.serialize(name, value, level)
  local basicSerialize = function(o)
    if type(o) == "number" then
      return tostring(o)
    elseif type(o) == "boolean" then
      return tostring(o)
    else -- assume it is a string
      return SourceObj.basicSerialize(o)
    end
  end
  local serialize_to_t = function(name, value, level)
    local var_str_tbl = {}
    if level == nil then
      level = ""
    end
    if level ~= "" then
      level = level .. "  "
    end
    table.insert(var_str_tbl, level .. name .. " = ")
    if type(value) == "number" or type(value) == "string" or type(value) == "boolean" then
      table.insert(var_str_tbl, basicSerialize(value) .. ",\n")
    elseif type(value) == "table" then
      table.insert(var_str_tbl, "\n" .. level .. "{\n")
      for k, v in pairs(value) do -- 序列化其字段
        local key
        if type(k) == "number" then
          key = string.format("[%s]", k)
        else
          key = string.format("[%q]", k)
        end
        table.insert(var_str_tbl, SourceObj.serialize(key, v, level .. "  "))
      end
      if level == "" then
        table.insert(var_str_tbl, level .. "} -- end of " .. name .. "\n")
      else
        table.insert(var_str_tbl, level .. "}, -- end of " .. name .. "\n")
      end
    else
      print("不能序列化一个: " .. type(value))
    end
    return var_str_tbl
  end
  local t_str = serialize_to_t(name, value, level)
  return table.concat(t_str)
end

-- --基本序列化
-- client_info = {
--   ucid = 's151e1321dsf',
--   name = '最帅'
-- }
-- Admins = Admins or {}
-- Admins[client_info.ucid] = client_info.name
-- file_s = SourceObj.serialize('Admins', Admins)
-- print(file_s)
-- --序列化
-- test = {}
-- b = {}
-- b['hello'] = 0
-- b['第三方'] = 'sdfd'
-- test['1'] = b
-- test['2'] = b
-- file_s2 = SourceObj.serialize('test', test)
-- print(file_s2)
-- print(file_s['s151e1321dsf'])

--Make the dostring function for the net environment, I will actually leave this one in global env.
