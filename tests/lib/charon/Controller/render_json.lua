local Controller = require 'charon.Controller'
local test = {}

test.should_return_http_status_500_if_errors = function()
  request = { params = function() return { json_callback = nil} end }
  local c = Controller.new()
  local object = { id = 1, name = 'John' }
  local status, headers, body = c:render({ output = 'json', value = object })
  assert( status == 200 )
end

test.should_return_http_header_application_json = function()
  request = { params = function() return { json_callback = nil} end }
  local c = Controller.new()
  local object = { id = 1, name = 'John' }
  local status, headers, body = c:render({ output = 'json', value = object })
  assert( headers[1] == 'Content-Type: application/json; charset=UTF-8', headers[1] )
end

test.should_return_http_body_encoded_json = function()
  request = { params = function() return { json_callback = nil} end }
  local c = Controller.new()
  local object = { id = 1, name = 'John' }
  local status, headers, body = c:render({ output = 'json', value = object })
  assert( body == [[{"name":"John","id":1}]], body )
end

test.should_return_with_json_callback = function()
  request = { params = function() return { json_callback = 'mycallback'} end }
  local c = Controller.new()
  local object = { id = 1, name = 'John' }
  local status, headers, body = c:render({ output = 'json', value = object })
  assert( body == [[mycallback({"name":"John","id":1})]], body )
end

return test
