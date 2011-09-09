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

local realvim = vim

local function escape_vim_string(s)
  return "'" .. s .. "'"
end

local function generate_scope_accessor(prefix)
  local mt = {}

  function mt:__index(key)
    return realvim.eval(prefix .. ':' .. key)
  end

  function mt:__newindex(key, value)
    error 'read-only for now'
  end

  mt.__metatable = false

  return setmetatable({}, mt)
end

local bridge_env = setmetatable({}, { __index = _G }) -- for now

bridge_env.global = generate_scope_accessor 'g'
bridge_env.buffer = generate_scope_accessor 'b'
bridge_env.window = generate_scope_accessor 'w'
bridge_env.tab    = generate_scope_accessor 't'
bridge_env.vim    = generate_scope_accessor 'v'

bridge_env.g = bridge_env.global
bridge_env.b = bridge_env.buffer
bridge_env.w = bridge_env.window
bridge_env.t = bridge_env.tab
bridge_env.v = bridge_env.vim

function vim.bridge(module)
  setmetatable(module, {
    __metatable = false,
    __index     = bridge_env,
  })
end
