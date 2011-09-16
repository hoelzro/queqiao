-- A slightly more complicated example, where we define
-- a function to fill in a hardcoded HTML template and
-- insert the results into the current buffer. Any values
-- required by the template are prompted for, and no value
-- will be prompted for more than once.  This example is
-- pretty simple; many possible improvements exist,
-- including support for multiple templates, templates stored
-- in files, delegating variable lookup to another object (like
-- g) before prompting, etc.
--
-- To invoke, load the queqiao plugin, and run
-- ":lua dofile('examples/html-template.lua')"
-- Afterwards, try ':call InsertTemplate()' and see what happens!
--
-- Requires the cosmo Lua module (http://cosmo.luaforge.net/)

pcall(require, 'luarocks.require')
local cosmo = require 'cosmo'

module('html_template', vim.bridge)

local function titlecase(s)
  -- string.gsub has multiple return values
  local first = string.gsub(s, '%f[%w]%l', function(letter)
    return string.upper(letter)
  end)
  return first
end

local template = [[
<html>
  <head>
    <title>$title</title>
  </head>
  <body>
    <h1>$title</h1>
  </body>
</html>
]]

local values = setmetatable({}, {
  __index = function(self, key)
    local value = input(titlecase(key) .. ': ')
    rawset(self, key, value)
    return value
  end
})

function InsertTemplate()
  local content = cosmo.fill(template, values)
  local curline = 0

  for line in string.gmatch(content, '[^\n]+') do
    append(curline, line)
    curline = curline + 1
  end
end
