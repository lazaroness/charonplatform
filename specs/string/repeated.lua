local test = {}

test['should two times of string'] = function()
  str = "this is a test"
  assert( str:repeated(2) == str .. str )
end

test['should tree times of string'] = function()
  str = "this is a test"
  assert( str:repeated(3) == str .. str .. str )
end

return test
