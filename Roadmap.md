0.01
====

- [ ] All Vim functions defined in eval.txt should be accessible from Lua
  - [ ] Functions that return something boolean-esque should coerce to booleans
- [ ] All Vim commands should be accessible from Lua
- [ ] Globally defined Lua functions should be accessible from Vim
  - [ ] When accessed from Vim, Lua-Vim functions that return booleans should have their outputs coerced
  - [ ] All types (except userdata, coroutines) should be returnable from Lua
    - [ ] Numbers
    - [ ] Strings
    - [ ] Booleans (coerced to numbers)
    - [ ] Nil
    - [ ] Functions
    - [ ] Tables
- [ ] All Vim scopes should support all Lua types (except functions, userdata, coroutines)
  - [✓] Numbers
  - [✓] Strings
  - [✓] Booleans (coerced to numbers)
  - [✓] Nil
  - [ ] Tables
- [ ] A user should be able to :source plugin.lua
- [ ] User-defined commands should be definable in Lua

Later
=====

- [ ] require() searches &runtimepath for files
- [ ] Auxiliary libraries should be locatable in lualib/ or something
- [ ] Lua functions should be able to access the word under the cursor
- [ ] Lua functions should be able to access command line ranges
- [ ] Lua should be able to iterate over the variables in a scope object (using pairs?)
- [ ] Vim objects (windows, buffers, etc) should be exposed to Lua
- [ ] Queqiao should have an extension/plugin mechanism
- [ ] Lua plugins should be able to be loaded automatically at startup, like Vim plugins
- [ ] Lua plugins should be able to define autoload functions
- [ ] Vim plugins should be able to load Lua functions from a .lua file
