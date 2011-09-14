local realvim = vim

module('global_vim_test', vim.bridge)

print(vim == realvim)
print(type(vim.eval))
print(type(vim.command))
