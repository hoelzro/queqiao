if ! has('lua')
    echomsg 'This plugin requires Lua support'
    finish
endif

let s:script_path = expand('<sfile>:r') . '.lua'
execute 'luafile ' . s:script_path
