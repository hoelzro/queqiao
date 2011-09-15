-- A silly little script that registers a global function which
-- prints and increments a buffer-scoped counter.
--
-- To try it out, load the queqiao plugin, and run ":lua dofile('examples/counter.lua')"
-- Afterwards, try ':call Incr()' and see what happens! (It's really not that cool)

module('counter', vim.bridge)

function Incr()
  if b.counter == nil then
    b.counter = 1
  end
  print(b.counter)
  b.counter = b.counter + 1
end
