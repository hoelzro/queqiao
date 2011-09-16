local realvim    = vim
local scope      = scope
local scope_abbr = scope_abbr

module('scope_test', vim.bridge)

local env = getfenv(1)

for _, scope in ipairs { env[scope], env[scope_abbr] } do
  scope.foo = 'bar'
  realvim.command('echo ' .. scope_abbr .. ':foo')
  scope.foo = 189
  realvim.command('echo ' .. scope_abbr .. ':foo')

  realvim.command('let ' .. scope_abbr .. ':foo = 179')
  print(scope.foo)
  realvim.command('let ' .. scope_abbr .. ':foo = "baz"')
  print(scope.foo)

  scope.foo = nil

  realvim.command('echo exists("' .. scope_abbr .. ':foo")')

  print(scope.foo)

  scope.foo = 17

  print(scope.foo)

  realvim.command('unlet ' .. scope_abbr .. ':foo')

  print(scope.foo)

  scope.foo = true

  print(scope.foo)

  scope.foo = false

  realvim.command('echo ' .. scope_abbr .. ':foo')
end
