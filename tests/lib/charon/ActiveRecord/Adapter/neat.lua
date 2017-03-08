local test    = {}
local json    = require('charon.json')
local Class   = require('charon.oop.Class')
local Person  = Class.new("Person", "ActiveRecord")
local Adapter = require("charon.ActiveRecord.Adapter")

test.beforeAll = function()
  ActiveRecord.reset()
  ActiveRecord.config = "config/active_record_sqlite.json"
  local sql = [[
  CREATE TABLE IF NOT EXISTS person (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name VARCHAR(250), observation TEXT,
    created_at TEXT, updated_at TEXT, total REAL
  )]]
  Person.adapter():execute(sql)
end

test.before = function()
  ActiveRecord.begin()
end

test.after = function()
  ActiveRecord.rollback()
end

test.afterAll = function()
  ActiveRecord.config = nil
end

test.should_create_neat_and_cache = function()
  local p = Person.new()
  p.name = "Chris Weidman"
  p:save()

  Adapter.neat  = {}
  Adapter.cache = {}

  local record = Person.find{ id = p.id }

  assert( Adapter.neat[record:cacheKey()].id == record.id )
  assert( Adapter.cache[record:cacheKey()] == record )
end

return test
