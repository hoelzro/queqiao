local realvim = vim

module('function_arguments', vim.bridge)

function TestFunction(a, b, c)
  print(a)
  print(b)
end

realvim.command('call TestFunction(1, "foo")')
