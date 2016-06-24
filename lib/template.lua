local M = {}

M.msecs  = QDateTime.currentMSecsSinceEpoch()
M.cache  = {}
M.source = {}
M.time   = 0

function M.compile(file_name)
  local data = os.read(file_name)

  local len  = data:len()
  local flag = false
  local i    = 0
  local j    = 0

  local buffer ="\n"
  buffer = buffer .. "return function(self, helper)\n"
  buffer = buffer .. "  local __buffer = ''\n"
  buffer = buffer .. "   __buffer = __buffer .. [[\n"

  while i < len do

    if data:sub(i, i+2) == '<%=' then
      buffer = buffer .. "]] .. tostring("
      flag = true
      i = i + 3
    elseif data:sub(i, i+1) == '<%'  then
      buffer = buffer .. "]]\n"
      i = i + 2
    elseif data:sub(i, i+2) == '-%>'  then
      if flag then
        buffer = buffer .. ") .. [["
        flag   = false
      else
        buffer = buffer .. "\n __buffer = __buffer .. [["
      end
      i = i + 2
    elseif data:sub(i, i+1) == '%>'  then
      if flag then
        buffer = buffer .. ") .. [[\n"
        flag   = false
      else
        buffer = buffer .. "\n __buffer = __buffer .. [["
      end
      i = i + 1

    else
      if data:sub(i, i) == '\n' then
        j = i + 1
        while data:sub(j, j) == ' ' do
          j = j + 1
        end
        if data:sub(j, j+2) == '<% ' then
          buffer = buffer .. data:sub(i, i)
          i = j - 1
        else
          buffer = buffer .. data:sub(i, i)
        end
      else
        buffer = buffer .. data:sub(i, i)
      end
    end
    i = i + 1

  end

  buffer = buffer .. "]] \n"
  buffer = buffer .. "  return __buffer \n"
  buffer = buffer .. "end"

  return M.filter(file_name, buffer)
end

function M.filter(file_name, buffer)
  return buffer
end

function M.build(file_name)
  M.source[file_name] = M.compile(file_name)
  return assert(loadstring(M.source[file_name]))
end

function M.execute(file_name, data, helper)
  local buffer = nil
  local time   = os.microtime()
  if not M.cache[file_name] then
    M.cache[file_name] = M.build(file_name)()
  end
  buffer = M.cache[file_name](data, helper)
  M.time = M.time + (os.microtime() - time)
  return buffer
end

function M.reload()
  -- M.cache = {}
  for file_name, source in pairs(M.source) do
    local fileInfo = QFileInfo.new(file_name)
    if fileInfo:lastModified():toMSecsSinceEpoch() > M.msecs then
      print("reload: " .. file_name)
      M.cache[file_name] = M.build(file_name)()
    end
  end

  M.msecs  = QDateTime.currentMSecsSinceEpoch()
end

function M.debug(file_name)
  local source = M.source[file_name]
  local buffer = ""
  local list   = QString.new(source):split('\n')
  for i = 1, list:size() do
    if i < 10 then
      buffer = buffer .. ' '
    end
    buffer = buffer .. i .. ") " .. list:at(i):__tostring() .. '\n'
  end
  return buffer
end

return M
