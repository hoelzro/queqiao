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

local function dict_from_list(list)
  local dict = {}

  for _, value in ipairs(list) do
    dict[value] = true
  end

  return dict
end

local coerce_boolean = dict_from_list {
  'did_filetype',
  'eventhandler',
  'haslocaldir',
  'pumvisible',
}

local nullaries = {
  'argc',
  'argidx',
  'changenr',
  'clearmatches',
  'complete_check',
  'did_filetype',
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

local function generate_nullary_function(name)
  if coerce_boolean[name] then
    return function()
      return realvim.eval(name .. '()') ~= 0
    end
  else
    return function()
      return realvim.eval(name .. '()')
    end
  end
end

for _, name in ipairs(nullaries) do
  bridge_env[name] = generate_nullary_function(name)
end

function bridge_env.expand(expr)
  return realvim.eval("expand(" .. util.escape_vim_string(expr) .. ")")
end
