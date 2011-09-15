module('eval_functions_test', vim.bridge)

local function compare(a, b)
  if type(a) == 'table' and type(b) == 'table' then
    local ok = true

    for k, v in pairs(a) do
      if not compare(v, b[k]) then
        ok = false
        break
      end
    end

    if ok then
      for k in pairs(b) do
        if a[k] == nil then
          ok = false
          break
        end
      end
    end

    return ok
  end
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
