-- Copyright 2016 The Charon Platform Authors.
-- All rights reserved.
-- Use of this source code is governed by a BSD-style
-- license that can be found in the LICENSE file.

local Array     = require('charon.Array')
local driver    = require('luasql.postgres')
local isblank   = require('charon.isblank')
local toboolean = require('charon.toboolean')
local Class     = require('charon.oop.Class')
local Adapter   = require('charon.ActiveRecord.Adapter')

local ActiveRecord_PostgresAdapter = Class.new("ActiveRecord.PostgresAdapter", Adapter)

------------------------------------------------------------------------------
-- CONNECT
-------------------------------------------------------------------------------

ActiveRecord_PostgresAdapter.instanceConnection = nil

function ActiveRecord_PostgresAdapter:connect()
  if ActiveRecord_PostgresAdapter.instanceConnection == nil then
    local env = driver.postgres()
    ActiveRecord_PostgresAdapter.instanceConnection, errmsg = env:connect(
      self.database, self.user, password, self.host
    )
    if errmsg ~= nil then
      ActiveRecord_PostgresAdapter.instanceConnection = nil
      error(string.format("connect to postgres error: %s\n", errmsg))
    end
  end
  return ActiveRecord_PostgresAdapter.instanceConnection
end

--------------------------------------------------------------------------------
-- ESCAPE
--------------------------------------------------------------------------------

function ActiveRecord_PostgresAdapter:escape(value)
  if value == nil then
    return " NULL "
  else
    if(type(value) == 'number') then
      return tostring(value) --:replace('.', ''):replace(',', '.')
    else
      return "'" .. tostring(value):replace("'", "''") .. "'"
    end
  end
end

--------------------------------------------------------------------------------
-- INSERT
--------------------------------------------------------------------------------

function ActiveRecord_PostgresAdapter:insert(record)
  local sql = 'INSERT INTO ' .. self.tableName .. ' '
  local col = ''
  local val = ''
  for column, value in pairs(record) do
    if not self:isReserved(column) then
    --for column, properties in pairs(self:columns(table)) do
      if not (column == self.primaryKey and isblank(record[self.primaryKey]))  then
        --local value = record[column]
        if #col > 0 then
          col = col .. ', '
        end
        col = col .. column

        if #val > 0 then
          val = val .. ', '
        end
        val = val .. self:escape(value)
      end
    end
  end
  sql = sql .. '(' .. col .. ') VALUES (' .. val .. ')'

  if self.primaryKey then
    sql = sql .. ' RETURNING ' .. self.primaryKey
  end

  return sql
end

--------------------------------------------------------------------------------
-- UPDATE
--------------------------------------------------------------------------------

function ActiveRecord_PostgresAdapter:update(record)
  self:bang(record)
  local sql = 'UPDATE ' .. self.tableName .. ' SET '
  local col = ''
  local key = self.tableName .. '_' .. tostring(record.id)

  if self:columns().updated_at then
    record.updated_at = self:createTimestamp()
  end

  for column, properties in pairs(self:columns()) do
    local value = record[column]
    if column ~= self.primaryKey then
      if #col > 0 then
        col = col .. ', '
      end
      col = col .. '"' .. column ..'"' .. " = " .. self:escape(value)
    end
  end
  local result = false
  local where = ' WHERE ' .. self.primaryKey .. " = " .. self:escape(record[self.primaryKey])
  sql = sql .. col .. where
  result = self:execute(sql)
  -- pending
  local pending = Adapter.pending[record:cacheKey()] or {}
  for column, properties in pairs(self:columns()) do
    pending[column] = record[column]
  end
  Adapter.pending[record:cacheKey()] = pending

  return result
end

--------------------------------------------------------------------------------
-- CREATE
--------------------------------------------------------------------------------

function ActiveRecord_PostgresAdapter:create(record)
  record:populate(record) -- TODO otimizar

  if self:columns().created_at then
    record.created_at = self:createTimestamp()
  end
  if self:columns().updated_at then
    record.updated_at = record.created_at or self:createTimestamp()
  end
  if self:columns().uuid then
    record.uuid = os.uuid()
  end

  self:bang(record)

  local sql    = self:insert(record)
  local cursor = self:execute(sql)
  if type(cursor) ~= 'number' then
    local row    = cursor:fetch({}, 'a')
    record.id    = tonumber(row[self.primaryKey])
    record.newRecord = false
    local key = record:cacheKey()
    Adapter.cache[key] = record
    Adapter.neat[key]  = record:dup()
    return record
  end
end

--------------------------------------------------------------------------------
-- COLUMNS
--------------------------------------------------------------------------------

function ActiveRecord_PostgresAdapter:columns()
  if self.instanceColumns == nil then
    sql = [[
      SELECT a.attname, format_type(a.atttypid, a.atttypmod), d.adsrc, a.attnotnull, i.indisprimary
        FROM pg_attribute a
        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
        LEFT JOIN pg_index i ON a.attrelid = i.indrelid  AND a.attnum = ANY(i.indkey) AND i.indisprimary
        WHERE a.attrelid = ']] .. self.tableName .. [['::regclass
          AND a.attnum > 0 AND NOT a.attisdropped
        ORDER BY a.attnum
    ]]

    local cursor = self:execute(sql)
    local result = {}
    for row in cursor:each({}) do
      local format = self:parserFormat(row.format_type)
      result[row.attname] = {
        default    = self:parserDefault(format, row.adsrc),
        notNull    = toboolean(row.attnotnull),
        format     = format,
        primaryKey = row.indisprimary == 't'
      }
    end
    self.instanceColumns = result
    cursor:close()
  end
  return self.instanceColumns

end

-------------------------------------------------------------------------------
-- PARSER DEFAULT
-------------------------------------------------------------------------------

function ActiveRecord_PostgresAdapter:parserDefault(format, value)
  if format == nil or value == nil then
    return nil
  else
    return self[format .. 'ParserDefault'](value)
  end
end

function ActiveRecord_PostgresAdapter.stringParserDefault(value)
  return value:replace("::character varying", ""):replace("'", "")
end

function ActiveRecord_PostgresAdapter.timeParserDefault(value)
  return value:replace("::time without time zone", ""):replace("'", "")
end

function ActiveRecord_PostgresAdapter.datetimeParserDefault(value)
  return value:replace("::timestamp without time zone", ""):replace("'", "")
end

function ActiveRecord_PostgresAdapter.dateParserDefault(value)
  return value:replace("::date", ""):replace("'", "")
end

function ActiveRecord_PostgresAdapter.numberParserDefault(value)
  return tonumber(value)
end

function ActiveRecord_PostgresAdapter.booleanParserDefault(value)
  return toboolean(value)
end

-------------------------------------------------------------------------------
-- PARSER FORMAT
-------------------------------------------------------------------------------

function ActiveRecord_PostgresAdapter:parserFormat(format_type)
  if string.contains(format_type, 'character') then
    return 'string'
  end

  if string.contains(format_type, 'timestamp') then
    return 'datetime'
  end

  if string.contains(format_type, 'time') then
    return 'time'
  end

  if string.contains(format_type, 'double') then
    return 'number'
  end

  if format_type == 'integer' then
    return 'number'
  end

  if format_type == 'real' then
    return 'number'
  end

  if format_type == 'bigint' then
    return 'number'
  end

  if format_type == 'smallint' then
    return 'number'
  end

  if format_type:contains('numeric') then
    return 'number'
  end

  if format_type == 'text' then
    return 'string'
  end

  if format_type == 'boolean' then
    return 'boolean'
  end

  if format_type == 'date' then
    return 'date'
  end

  if format_type == 'bytea' then
    return 'string'
  end

  if format_type == 'tsvector' then
    return 'string'
  end

  error('format_type: ' .. format_type ..' not resolved')
end

-------------------------------------------------------------------------------
-- TABLE EXISTS
-------------------------------------------------------------------------------

function ActiveRecord_PostgresAdapter:tableExists(tableName)
  local sql  = string.format([[
    SELECT 1
    FROM   pg_catalog.pg_class c
    JOIN   pg_catalog.pg_namespace n ON n.oid = c.relnamespace
    WHERE  c.relname = '%s']], tableName)
  local cursor = self:execute(sql)
  local result = false
  if type(cursor) == 'userdata' then
    result = cursor:fetch({}, 'a') ~= nil
    cursor:close()
  end
  return result
end

-------------------------------------------------------------------------------
-- PREPARE MIGRATIONS
-------------------------------------------------------------------------------

function ActiveRecord_PostgresAdapter:prepareMigration()
  if not self:tableExists('schema_migration') then
    self:execute([[
      CREATE TABLE schema_migration (version VARCHAR(250) NOT NULL UNIQUE)
    ]])
  end

  local list   = {}
  local sql    = "SELECT version FROM schema_migration"
  local cursor = self:execute(sql)
  for row in cursor:each() do
    list[row.version] = true
  end
  cursor:close()
  return list
end

-------------------------------------------------------------------------------
-- TABLES
-------------------------------------------------------------------------------

function ActiveRecord_PostgresAdapter:tables()
  local list = Array.new()
  local sql  = string.format([[
    SELECT table_schema, table_name
    FROM information_schema.tables
    WHERE table_schema = 'public'
    AND table_type = 'BASE TABLE'
    ORDER BY table_name
  ]])

  local cursor = self:execute(sql)
  for row in cursor:each() do
    table.insert(list, row.table_name)
  end

  table.sort(list)

  cursor:close()
  return list
end

return ActiveRecord_PostgresAdapter
