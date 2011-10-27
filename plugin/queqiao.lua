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

local setmetatable      = setmetatable
local bridge_env        = setmetatable({}, { __index = _G }) -- for now
local type              = type
local rawget            = rawget
local rawset            = rawset
local smatch            = string.match
local format            = string.format
local gsub              = string.gsub
local sbyte             = string.byte
local function_registry = {}
local util              = {}

_G.function_registry = function_registry
_G.bridge_env        = bridge_env
_G.util              = util

function util.escape_vim_string(s)
  return '"' .. gsub(s, '.', function(c)
    return format('\\%03o', sbyte(c))
  end) .. '"'
end

function util.register_function(fn)
  function_registry[#function_registry + 1] = fn -- XXX cleanup?
  return #function_registry
end

require 'queqiao.functions'
require 'queqiao.scopes'
require 'queqiao.commands'

_G.bridge_env = nil
_G.util       = nil

rawset(vim, 'bridge', function(module)
  local function_storage = setmetatable({}, { __index = bridge_env })

  setmetatable(module, {
    __metatable = false,
    __index     = function_storage,
    __newindex  = function(self, k, v)
      local t = type(v)

      if t == 'function' then
        if smatch(k, '^%u') then
          local id = util.register_function(v)
          -- XXX return value
          vim.command(format([[
function! %s(...)
  lua << LUA
local args = {}
for i = 1, vim.eval('a:0') do
  args[#args + 1] = vim.eval('a:' .. tostring(i))
end
_G.function_registry[%d](unpack(args))
LUA
endfunction
          ]], k, id))
        end
      elseif t == 'nil' then
        if type(rawget(function_storage, k)) == 'function' then
          vim.command('delfunction ' .. k)
        end
      end

      rawset(function_storage, k, v)
    end
  })
end)
