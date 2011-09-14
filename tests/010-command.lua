local realvim = vim

module('command_test', vim.bridge)

local function MyCommand()
  print 'called my command'
end

command('MyCommand', MyCommand)

realvim.command(':MyCommand')
