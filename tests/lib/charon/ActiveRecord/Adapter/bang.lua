local test    = {}
local json    = require('charon.json')
local Class   = require('charon.oop.Class')
local Adapter = require("charon.ActiveRecord.Adapter")
local Person  = Class.new("Person", "ActiveRecord")

test.beforeAll = function()
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

test.should_execute_save = function()
  Person.saveValidate = function(self)
    if self.name == nil or self.name == '' then
      self.errors.name = "invalid"
    end
  end
  Person.contract('save')

  local person = Person.new()
  person.name = ""
  local status, message = person:pcall('save')
  assert(status == false)
  assert(message.name == 'invalid', message.name)
end

test.should_execute_bang = function()
  local person = Person.new()
  person.errors = {}
  person.errors.name = 'is invalid'
  local adapter = Adapter.new()
  local status, message = pcall(adapter.bang, adapter, person)
  assert( status == false ) 
  assert( message.name == 'is invalid' )
end

return test
