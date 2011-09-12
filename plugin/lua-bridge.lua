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

local setmetatable = setmetatable
local bridge_env   = setmetatable({}, { __index = _G }) -- for now
local type         = type
local rawset       = rawset
local smatch       = string.match
local format       = string.format
local gsub         = string.gsub
local sbyte        = string.byte

_G.function_registry = {}

_G.bridge_env = bridge_env
util          = {}

function util.escape_vim_string(s)
  return '"' .. gsub(s, '.', function(c)
    return format('\\%03o', sbyte(c))
  end) .. '"'
end

require 'lua-bridge-functions'
require 'lua-bridge-scopes'
require 'lua-bridge-commands'

_G.bridge_env = nil
util          = nil

function vim.bridge(module)
  local function_storage = setmetatable({}, { __index = bridge_env })

  setmetatable(module, {
    __metatable = false,
    __index     = function_storage,
    __newindex  = function(self, k, v)
      local t = type(v)

      if t == 'function' then
        if smatch(k, '^%u') then
          _G.function_registry[#_G.function_registry + 1] = v -- XXX cleanup?
          local id = #_G.function_registry

          -- XXX register function
          vim.command(format([[
function! %s()
  lua _G.function_registry[%d]()
endfunction
          ]], k, id))
        end
        rawset(function_storage, k, v)
      else
        rawset(self, k, v)
      end
    end
  })
end
