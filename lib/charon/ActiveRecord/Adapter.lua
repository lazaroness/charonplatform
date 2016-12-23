-- Copyright 2016 The Charon Platform Authors.
-- All rights reserved.
-- Use of this source code is governed by a BSD-style
-- license that can be found in the LICENSE file.

local Class = require('charon.oop.Class')

ActiveRecord_Adapter = Class.new("ActiveRecord_Adapter")

ActiveRecord_Adapter.reserved = {'new_record', 'class', 'errors'}

ActiveRecord_Adapter.errors = {}

-------------------------------------------------------------------------------
-- FORMAT
-------------------------------------------------------------------------------

local format = {}

format.boolean = function(value)
  return "'".. tostring(value) .. "'"
end

format.number = function(value)
  return tostring(value):replace('.', ''):replace(',', '.')
end

format.string = function(value)
  return "'".. value .. "'"
end

format.table = function(value)
  return table.concat(value, ',')
end

format.userdata = function(value)
  return "'" .. value:__tostring() .. "'"
end

--------------------------------------------------------------------------------
-- FINDERS
--------------------------------------------------------------------------------
ActiveRecord_Adapter.finders = {}

ActiveRecord_Adapter.finders['string'] = function(value)
  if value == 'NULL' or value == 'NOT NULL' then
    return ' IS ' .. value
  else
    return " = '".. value .. "'"
  end
end

ActiveRecord_Adapter.finders['boolean'] = function(value)
  return " = '".. tostring(value) .. "'"
end

ActiveRecord_Adapter.finders['number'] = function(value)
  return " = " .. tostring(value):replace('.', ''):replace(',', '.')
end

ActiveRecord_Adapter.finders['table'] = function(value)
  return " = '".. value['__finder'](value) .. "'"
end

ActiveRecord_Adapter.finders['userdata'] = function(value)
  return " = '".. value['__finder'](value) .. "'"
end

--------------------------------------------------------------------------------
-- DEFAULT VALUES
--------------------------------------------------------------------------------

function ActiveRecord_Adapter:defaultValues(record)
  record.new_record = true
  for column, properties in pairs(self:columns()) do
    if record[column] == nil then -- and properties.not_null then
      record[column] = properties.default
    end
  end
end

--------------------------------------------------------------------------------
-- ESCAPE
--------------------------------------------------------------------------------

function ActiveRecord_Adapter:escape(value)
  if value == nil then
    return " NULL "
  else
    if(type(value) == 'number') then
      return tostring(value) --:replace('.', ''):replace(',', '.')
    else
      return "'" .. tostring(value) .. "'"
    end
  end
end

--------------------------------------------------------------------------------
-- isReserved
--------------------------------------------------------------------------------

function ActiveRecord_Adapter:isReserved(column)
  for _, value in ipairs(ActiveRecord_Adapter.reserved) do
    if value == column then
      return true
    end
  end
  return false
end

--------------------------------------------------------------------------------
-- WHERE
--------------------------------------------------------------------------------

function ActiveRecord_Adapter:where(values, flag)

  local result = ""
  local col    = ""
  local join   = values.join
  local order  = values.order
  local limit  = values.limit

  values.join    = nil
  values.binding = nil
  values.order   = nil
  values.limit   = nil

  if type(join) == 'table' then
    local tmp = join[1]
    for index, value in pairs(join) do
      tmp = string.replace(tmp, '$' .. index, format[type(value)](value))
    end
  join = tmp
  end

  if values.where then
    local where = values.where
    where = ' WHERE ' .. where
    for index, value in pairs(values) do
      where = string.replace(where, '$' .. index, format[type(value)](value))
    end
    result = where
  else
    for index, value in pairs(values) do
      if ActiveRecord_Adapter.reserved[index] == nil then
        if #col > 0 then
          col = col .. ' AND '
        end
        col = col .. index .. self.finders[type(value)](value)
      end
    end
    if flag and #col == 0 then
      error "parameters for find empty"
    end
    result = ' WHERE ' .. result .. col
  end
  if join then
    result = join .. result
  end
  if order then
    result = result .. ' ORDER BY ' .. order
  end
  if limit then
    result = result .. ' LIMIT ' .. limit
  end

  return result
end

--------------------------------------------------------------------------------
-- SELECT
--------------------------------------------------------------------------------

function ActiveRecord_Adapter:select(params, flag)
  return 'SELECT ' .. self.table_name .. '.* FROM ' .. self.table_name .. " " .. self:where(params, flag)
end

--------------------------------------------------------------------------------
-- DELETE
--------------------------------------------------------------------------------

function ActiveRecord_Adapter:destroy(record)
  local values = {[self.primary_key] = record[self.primary_key]}
  local sql = 'DELETE FROM ' .. self.table_name .. " " .. self:where(values)
  local result = self:execute(sql)
  return result
end

-------------------------------------------------------------------------------
-- COUNT
-------------------------------------------------------------------------------

function ActiveRecord_Adapter:count()
  error("count not implemented")
end

--------------------------------------------------------------------------------
-- INSERT
--------------------------------------------------------------------------------

function ActiveRecord_Adapter:insert(values)
  error('not implemeted')
end

--------------------------------------------------------------------------------
-- UPDATE
--------------------------------------------------------------------------------

function ActiveRecord_Adapter:update(values)
  error('not implemeted')
end

--------------------------------------------------------------------------------
-- CREATE
--------------------------------------------------------------------------------

function ActiveRecord_Adapter:create(record)
  error('not implemeted')
end

--------------------------------------------------------------------------------
-- FIND
--------------------------------------------------------------------------------

function ActiveRecord_Adapter:find(params)
  error('find not implemeted')
end

--------------------------------------------------------------------------------
-- ALL
--------------------------------------------------------------------------------

function ActiveRecord_Adapter:all(params)
  error('all not implemeted')
end

--------------------------------------------------------------------------------
-- COLUMNS
--------------------------------------------------------------------------------

function ActiveRecord_Adapter:columns(sql)
  error('not implemeted')
end


--------------------------------------------------------------------------------
-- LAST_ID
--------------------------------------------------------------------------------

function ActiveRecord_Adapter:lastid()
  error('not implemeted')
end

--------------------------------------------------------------------------------
-- EXECUTE
--------------------------------------------------------------------------------

function ActiveRecord_Adapter:execute(sql)
  error('not implemeted')
end

--------------------------------------------------------------------------------
-- QUERY
--------------------------------------------------------------------------------

function ActiveRecord_Adapter:query(sql)
  error('not implemeted')
end

--------------------------------------------------------------------------------
-- BEGIN
--------------------------------------------------------------------------------

function ActiveRecord_Adapter:begin()
  error('not implemeted')
end

--------------------------------------------------------------------------------
-- ROOLBACK
--------------------------------------------------------------------------------

function ActiveRecord_Adapter:rollback()
  error('not implemeted')
end

--------------------------------------------------------------------------------
-- COMMIT
--------------------------------------------------------------------------------

function ActiveRecord_Adapter:commit()
  error('not implemeted')
end


--------------------------------------------------------------------------------
-- POPULATE
--------------------------------------------------------------------------------

function ActiveRecord_Adapter:populate()
  error('not implemeted')
end

--------------------------------------------------------------------------------
-- BANG !
--------------------------------------------------------------------------------

function ActiveRecord_Adapter:bang(record)
  local flag = false
  for k, v in pairs(record.errors) do
    flag = true
    break
  end
  if flag then
    local errors = record.errors
    record.errors = {}
    errors.traceback = debug.traceback()
    error(errors)
  end
end

--------------------------------------------------------------------------------
-- VALIDATE
--------------------------------------------------------------------------------

function ActiveRecord_Adapter:validate(record, params)
  self["validate" .. params[1]:capitalize()](self, record, params)
end

function ActiveRecord_Adapter:validatePresence(record, params)
  if record[params.column] == nil or record[params.column] == '' then
    record.errors[params.column] = params.message
  end
end

function ActiveRecord_Adapter:validateBoolean(record, params)
  if not parse.isBoolean(record[params.column]) then
    record.errors[params.column] = params.message
  end
end

function ActiveRecord_Adapter:validateLength(record, params)
  if type(record[params.column]) == 'string' then
    local length = #record[params.column]
    if params.min and length < params.min then
      record.errors[params.column] = params.message
    end
    if params.max and length > params.max then
      record.errors[params.column] = params.message
    end
  else
    record.errors[params.column] = params.message
  end
end

function ActiveRecord_Adapter:validateUnique(record, params)
  local value  = record[params.column]
  if value ~= nil and value ~= '' then
    local result = self:all{ [params.column] = value }
    if record[self.primary_key] == nil and #result > 0 then
      record.errors[params.column] = params.message
    else
      for _, res in ipairs(result) do
        if record[self.primary_key] ~= res[self.primary_key] then
          record.errors[params.column] = params.message
          break
        end
      end
    end
  end
end

-------------------------------------------------------------------------------
-- LOAD
-------------------------------------------------------------------------------

function ActiveRecord_Adapter:sql(name, params)
  local table   = self.record_class.table_name
  local query   = (self.record_class.query_prefix or '') .. 'query/' .. table
    query  = query .. '/' .. name .. '.sql'
  local values  = self.record_class.where(params)
  if values == nil then
    error(self.record_class.className .. "#where not return valid query")
  end
  local binding = values.binding
  if not os.exists(query) then
    error(query .. ' file not exists')
  end
  local sql     = os.read(query)
  local where   = self.record_class.adapter():where(values)

  if binding then
    for index, value in pairs(binding) do
      sql = string.replace(sql, '$' .. index, format[type(value)](value))
    end
  end

  return (sql .. where)
end

-------------------------------------------------------------------------------
-- CREATE TIMESTAMP
-------------------------------------------------------------------------------

function ActiveRecord_Adapter:createTimestamp()
  if CHARON_ENV == 'test' then
    local clock  = tostring(os.clock())
    local index  = clock:indexOf('.')
    return os.date("%Y/%m/%d %H:%M:%S.") .. clock:mid(index+1, -1)
  else
    return os.date("%Y/%m/%d %H:%M:%S")
  end
end

-------------------------------------------------------------------------------
-- TABLE EXISTS
-------------------------------------------------------------------------------

function ActiveRecord_Adapter:tableExists(tableName)
  error("tableExists not implemented")
end

-------------------------------------------------------------------------------
-- PREPARE MIGRATIONS
-------------------------------------------------------------------------------

function ActiveRecord_Adapter:prepareMigration()
  error("prepare migrations not implemented")
end

return ActiveRecord_Adapter
