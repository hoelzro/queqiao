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

local bridge_env        = bridge_env
local escape_vim_string = escape_vim_string
local realvim           = vim
local setmetatable      = setmetatable
local type              = type
local util              = util

local function generate_scope_accessor(prefix)
  local mt = {}

  function mt:__index(key)
    if realvim.eval('exists(' .. util.escape_vim_string(prefix .. ':' .. key) .. ')') == 1 then
      return realvim.eval(prefix .. ':' .. key)
    else
      return nil
    end
  end

  function mt:__newindex(key, value)
    local t = type(value)

    if t == 'nil' then
      realvim.command('unlet ' .. prefix .. ':' .. key)
    else
      if t == 'string' then
        value = util.escape_vim_string(value)
      elseif t == 'boolean' then
        value = value and 1 or 0
      elseif t ~= 'number' then
        error "Sorry, I only support numbers, booleans, strings, and nils at the moment"
      end

      realvim.command('let ' .. prefix .. ':' .. key .. ' = ' .. value)
    end
  end

  mt.__metatable = false

  return setmetatable({}, mt)
end

bridge_env.global  = generate_scope_accessor 'g'
bridge_env.buffer  = generate_scope_accessor 'b'
bridge_env.window  = generate_scope_accessor 'w'
bridge_env.tab     = generate_scope_accessor 't'
local vim_accessor = generate_scope_accessor 'v'
setmetatable(vim, { __index = vim_accessor, __newindex = vim_accessor, __metatable = false })

bridge_env.g = bridge_env.global
bridge_env.b = bridge_env.buffer
bridge_env.w = bridge_env.window
bridge_env.t = bridge_env.tab
bridge_env.v = bridge_env.vim
