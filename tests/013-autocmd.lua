local realvim = vim

module('autocmd_test', vim.bridge)

local count = 0
local function countbuffers()
  count = count + 1
end

autocmd('BufCreate', '*', countbuffers)
autocmd('BufCreate', '*', "echo 'in autocmd'")

print(count)
realvim.command ':new'
print(count)
