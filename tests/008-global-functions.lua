local realvim = vim

module('global_functions', vim.bridge)

function foobar()
end

function FooBar()
end

realvim.command('echo exists("*foobar")')
realvim.command('echo exists("*FooBar")')
