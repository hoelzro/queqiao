# Queqiao - A better bridge between Vim and Lua

Provides a higher-level interface for writing Vim plugins in Lua.

# Why Queqiao?

In Chinese mythology, queqiao (or 鵲橋) is a bridge of birds that represents the Milky Way.  Lua projects
are typically named after astronomy/space terms (Telescope for unit testing, Orbit for MVC web development),
so I figured a celestial bridge would be the perfect name for this project.

# How do I say "queqiao?"

It sounds kind of like _chweh-cheeow_.  For my butchered pronunciation, check http://hoelz.ro/projects/queqiao.

# Why Lua?

Several reasons, actually.

## Lua is easy to learn.

Lua is a dead-simple language; most people I know can get through the whole manual in an afternoon.

## Lua is a "common denominator".

One of my favorite languages is Perl, but I realize that it's not everyone's favorite.  I wanted people from
all communities to make use of this plugin.

## Lua is powerful.

In spite of (or perhaps because of) its simplicity, Lua is an extremely powerful language.  Because of its features,
implementing things like this:

```lua
    b.my_plugin_loaded = 1 -- equivalent to let b:my_plugin_loaded = 1
```

and this:

```lua
    function PrintNumLines()
        print(line '$')
    end --[[ equivalent to
      function! PrintNumLines()
        echo line('$')
      endfunction
    ]]
    -- you can even do :call PrintNumLines()!
```

are fairly simple.

If you're not satisfied with these reasons and **need** to have this functionality for your language, I encourage
you to port it!

# Contact Me

rob at hoelz.ro
