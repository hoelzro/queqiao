-- Copyright (c) 2011 Rob Hoelz
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in the
-- Software without restriction, including without limitation the rights to use, copy,
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
-- and to permit persons to whom the Software is furnished to do so, subject to the
-- following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
-- FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
-- COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
-- AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
-- WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

local ipairs     = ipairs
local bridge_env = bridge_env
local realvim    = vim
local util       = util
local tconcat    = table.concat

local function dict_from_list(list)
  local dict = {}

  for _, value in ipairs(list) do
    dict[value] = true
  end

  return dict
end

local coerce_boolean = dict_from_list {
  'append',
  'did_filetype',
  'eventhandler',
  'haslocaldir',
  'pumvisible',
}

local vim_functions = {
  'append',
  'argc',
  'argidx',
  'changenr',
  'clearmatches',
  'complete_check',
  'did_filetype',
  'expand',
  'eventhandler',
  'foldtext',
  'foreground',
  'getcharmod', -- coerce to non-numbers?
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
  'line',
  'localtime',
  'pumvisible',
  'serverlist',
  'tagfiles',
  'tempname',
  'undotree',
  'wincol',
  'winline',
  'winrestcmd',
  'winsaveview',
}

local function serialize_args(...)
  local n = select('#', ...)
  local t = {}

  for i = 1, n do
    local v    = select(i, ...)
    local type = type(v)

    if type == 'number' then
      v = tostring(v)
    elseif type == 'string' then
      v = util.escape_vim_string(v)
    end

    t[#t + 1] = v
  end

  return tconcat(t, ',')
end

local function generate_function(name)
  if coerce_boolean[name] then
    return function(...)
      return realvim.eval(name .. '(' .. serialize_args(...) .. ')') ~= 0
    end
  else
    return function(...)
      return realvim.eval(name .. '(' .. serialize_args(...) .. ')')
    end
  end
end

for _, name in ipairs(vim_functions) do
  bridge_env[name] = generate_function(name)
end
