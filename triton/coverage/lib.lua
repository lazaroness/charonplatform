CHARON_ENV = os.getenv("CHARON_ENV") or "test"

local QDirIterator = require 'QDirIterator'
local QFileInfo    = require 'QFileInfo'
local test         = require 'charon.test'
local template     = require 'charon.template'
local coverage     = require 'charon.coverage'
local json         = require 'charon.jsonp'
local start        = os.microtime()
local files        = {}

-------------------------------------------------------------------------------
-- TRITON START
-------------------------------------------------------------------------------

function triton_start()
  local dir = 'coverage'
  if not os.exists(dir) then
    os.mkdir(dir)
  end

  local iterator = QDirIterator.new('./lib', {"Subdirectories"})
  while(iterator:hasNext()) do
    iterator:next()
    local fileInfo = iterator:fileInfo()
    if fileInfo:filePath():endsWith(".lua") then
      local filePath = fileInfo:filePath()
      print(filePath)
      table.insert(files, filePath)
      triton.enqueue(filePath)
    end
  end
end

function triton_run(fileName)
  local tests     = {}
  local dirName   = fileName:gsub(".lua", ""):replace("./", "./tests/")
  if not os.exists(dirName) then
    triton.append("message", string.format("warning: directory %s not exists\n", dirName))
  end
  local modelName = dirName:gsub("./tests/lib/", ""):gsub("/", ".")
  local iterator  = QDirIterator.new(dirName)

  if modelName == 'charon.coverage' then
    package.loaded[modelName] = nil
  end

  while(iterator:hasNext()) do
    iterator:next()
    local fileInfo = iterator:fileInfo()
    if fileInfo:filePath():endsWith(".lua") then
      table.insert(tests, fileInfo:filePath())
    end
  end

  coverage.reset()
  coverage.start()
  local results = test.execute(tests)
  coverage.stop()

  for fileName, result in pairs(results) do
    for description, result in pairs(result) do
      triton.count('tests')
      if result.status ~= 'ok' then
        local buffer = description .. '\n'
        if result.msg and tostring(result.msg):len() > 0  then
          buffer = buffer .. tostring(result.msg) .. '\n'
        end
        triton.append('message', fileName .. '\n' .. buffer)
      end

      triton.count(result.status)
    end
  end

  local dir     = 'coverage'
  local file    = fileName
  local tpl     = CHARON_PATH .. "/lib/charon/coverage/templates/file.html"
  local dump    = coverage.dump()
  local data    = coverage.analyze(fileName)
  local buffer  = template.execute(tpl, data )
  local file    = io.open((dir .. "/" .. fileName:replace("/", "-") .. '.html'), "w")
  file:write(buffer)
  file:close()
  file = io.open((dir .. "/" .. fileName:replace("/", "-") .. '.json'), "w")
  file:write(json.encode(data))
  file:close()
end

-------------------------------------------------------------------------------
-- TRITON STOP
-------------------------------------------------------------------------------

function triton_stop()
  print('')
  local dir    = 'coverage'
  local tpl    = CHARON_PATH .. "/lib/charon/coverage/templates/index.html"
  local data   = {files = files, time = (os.microtime() - start), total = triton.total('tests')}
  local buffer = template.execute(tpl, data)

  local file   = io.open((dir .. "/" .. 'index.html'), "w")
  file:write(buffer)
  file:close()

  local result = "%i tests, %i pendings, %i failures"
  print('\n' .. triton.result('message'))
  print(string.format(result, triton.total('tests'), triton.total('failure'), triton.total('pending')))
  print(string.format("Finished in %.2f seconds", os.microtime() - start))
end
