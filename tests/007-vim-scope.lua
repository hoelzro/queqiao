scope      = 'vim'
scope_abbr = 'v'

local realvim = vim

module('scope_test', vim.bridge)

local env = getfenv(1)

for _, scope in ipairs { env[scope], env[scope_abbr] } do
  scope.statusmsg = 'bar'
  realvim.command('echo ' .. scope_abbr .. ':statusmsg')
  scope.statusmsg = 189
  realvim.command('echo ' .. scope_abbr .. ':statusmsg')

  realvim.command('let ' .. scope_abbr .. ':statusmsg = 179')
  print(scope.statusmsg)
  realvim.command('let ' .. scope_abbr .. ':statusmsg = "baz"')
  print(scope.statusmsg)

  print(scope.foo)
end
