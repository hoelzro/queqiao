module('eval_functions_test', vim.bridge)

local comparators = setmetatable({}, { __index = function(self, _)
  return self.general
end } )

local function compare(a, b)
  local typea = vim.type(a)
  local typeb = vim.type(b)

  if typea ~= typeb then
    return false
  end

  return comparators[typea](a, b)
end

function comparators.table(a, b)
  for k, v in pairs(a) do
    if not compare(v, b[k]) then
      return false
    end
  end

  if ok then
    for k in pairs(b) do
      if a[k] == nil then
        return false
      end
    end
  end

  return true
end

function comparators.list(a, b)
  local lena = #a
  local lenb = #b

  if lena ~= lenb then
    return false
  end

  for i = 1, lena do
    local elementa = a[i]
    local elementb = b[i]

    if not compare(a[i], b[i]) then
      return false
    end
  end

  return true
end

function comparators.dict(a, b)
  for k, v in a() do
    if not compare(v, b[k]) then
      return false
    end
  end

  for k, v in b() do
    if a[k] == nil then
      return false
    end
  end

  return true
end

function comparators.general(a, b)
  return a == b
end

local coerce_boolean = {
  append       = true,
  did_filetype = true,
  eventhandler = true,
  haslocaldir  = true,
  pumvisible  = true,
}

local functions = {
  'argc',
  'argidx',
  'changenr',
  'clearmatches',
  'complete_check',
  'did_filetype',
  'eventhandler',
  'foldtext',
  'foreground',
  'getcharmod',
  'getcmdline',
  'getcmdpos',
  'getcmdtype',
  'getcwd',
  'getmatches',
  'getpid',
  'getqflist',
  'getwinposx',
  'getwinposy',
  'haslocaldir',
  'hostname',
  'inputrestore',
  'inputsave',
  'localtime',
  'pumvisible',
  'serverlist',
  'tagfiles',
  'undotree',
  'wincol',
  'winline',
  'winrestcmd',
  'winsaveview',
}

local env = getfenv(1)

for _, name in ipairs(functions) do
  local got      = env[name]()
  local expected = vim.eval(name .. '()')

  if coerce_boolean[name] then
    expected = expected ~= 0
  end

  print(name .. ' - ' .. tostring(compare(got, expected)))
end

local value = append(0, 'foo')
print('append - ' .. tostring(value))

print('expand - ' .. tostring(expand('%') == vim.eval('expand("%")')))
print('line - ' .. tostring(line('.') == vim.eval('line(".")')))
