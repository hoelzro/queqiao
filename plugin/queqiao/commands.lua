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

local realvim  = vim
local _G       = _G
local format   = string.format
local type     = type
local tostring = tostring
local util     = util

_G.bridge_commands = {} -- XXX weak values? how to clean up commands?

function bridge_env.command(name, impl)
  _G.bridge_commands[#_G.bridge_commands + 1] = impl
  realvim.command(format('command %s lua _G.bridge_commands[%d]()', name, #_G.bridge_commands))
end

function bridge_env.autocmd(event, pattern, action)
  if type(action) == 'function' then
    local id = util.register_function(action)
    action   = 'lua _G.function_registry[' .. tostring(id) .. ']()'
  end
  realvim.command(format('autocmd %s %s %s', event, pattern, action))
end
