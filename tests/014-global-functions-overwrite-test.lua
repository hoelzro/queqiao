local realvim = vim

module('global_function_overwrite_test', vim.bridge)

FooBar = 17

realvim.command 'echo exists("*FooBar")'

function FooBar()
end

realvim.command 'echo exists("*FooBar")'

-- overwrite function (exists '*FooBar')
