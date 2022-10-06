# Pandoc lua logging

This library provides pandoc-aware functions for dumping and logging lua objects. It can be used standalone but is primarily intended for using within pandoc lua filters.

# Getting started

Put `logging.lua` somewhere where your pandoc lua filters can access it. For example, if your lua filters are in `$HOME/.local/share/pandoc/filters` you could put `logging.lua` in the same place and set the [`LUA_PATH`](https://www.lua.org/manual/5.4/manual.html#pdf-package.path) environment variable:

```
export LUA_PATH="$HOME/.local/share/pandoc/filters/?.lua;;"
```

Now try this `simple.lua` filter:

```lua
local logging = require 'logging'

function Pandoc(pandoc)
    logging.temp('pandoc', pandoc)
end
```

...with this `simple.md` input:

```markdown
text
```

...to get this output on `stderr`:

```text
(#) pandoc Pandoc {
  blocks: Blocks {
    [1] Para {
      content: Inlines {
        [1] Str "text"
      }
    }
  }
  meta: Meta {}
}
```

The `logging.temp()` function is intended for temporary debug output (hence its name) and always generates output. You can use `logging.error()`, `logging.warning()`, `logging.info()` etc. to generate output that's conditional on the log level.

The initial log level is derived from the pandoc `--quiet`, `--verbose` and `--trace` command-line options. By default (i.e., if none of these options are specified) the log level is `0` and only errors and warnings will be output.

With this `para.lua` filter:

```lua
local logging = require 'logging'

function Para(para)
    logging.info('para', para)
end
```

...by default there's no output:

```text
% pandoc simple.md -L para.lua >/dev/null
```

...but `--verbose` sets the log level to `1` (`info`):

```text
% pandoc simple.md -L para.lua >/dev/null --verbose
[INFO] Running filter para.lua
(I) para Para {content: Inlines {[1] Str "text"}}
[INFO] Completed filter para.lua in 8 ms
```

All lua objects can be passed to `logging.info()` etc., and they will be output in a form that should be useful for lua filter development and debugging. The output is intended to be a faithful representation of the [pandoc lua types](https://pandoc.org/lua-filters.html#module-pandoc) and should make it easy to "dig down". For example, you can see that:

* `para` is a [Para](https://pandoc.org/lua-filters.html#type-para) instance
* `para.content` is an [Inlines](https://pandoc.org/lua-filters.html#type-inlines) instance
* `para.content[1]` is a [Str](https://pandoc.org/lua-filters.html#type-str) instance
* `para.content[1].text` is a string

...and you could reference all of these directly in the filter. For example, with this `para2.lua` filter:

```lua
local logging = require 'logging'

function Para(para)
    logging.info('para', para)
    logging.info('para.content', para.content)
    logging.info('para.content[1]', para.content[1])
    logging.info('para.content[1].text', para.content[1].text)
end
```

...you get this:

```text
% pandoc simple.md -L para2.lua >/dev/null --verbose
[INFO] Running filter para2.lua
(I) para Para {content: Inlines {[1] Str "text"}}
(I) para.content Inlines {[1] Str "text"}
(I) para.content[1] Str "text"
(I) para.content[1].text text
[INFO] Completed filter para2.lua in 8 ms
```

Why is the last `text` not quoted?

# Module contents

## logging.type(value)

Returns whatever [`pandoc.utils.type()`](https://pandoc.org/lua-filters.html#pandoc.utils.type) returns, modified as follows:

* Spaces are replaced with periods, e.g., `pandoc Row` becomes `pandoc.Row`
* `Inline` and `Block` are replaced with the corresponding `tag` value, e.g. `Emph` or `Table`

## logging.spairs(list [, comp])

Like `pairs()` but with sorted keys. Keys are converted to strings and sorted
using `table.sort(keys, comp)` so by default they're visited in alphabetical
order.

## logging.dump(value [, maxlen])

Returns a pandoc-aware string representation of `value`, which can be an arbitrary lua object.

The returned string is a single line if not longer than `maxlen` (default `70`), and is otherwise multiple lines (with two character indentation). The string is not terminated with a newline.

Map keys are sorted alphabetically in order to ensure that output is repeatable.

See the *Getting started* section for examples.

## logging.output(...)

Pass each argument to `logging.dump()` and output the results to `stderr`, separated by single spaces and terminated (if necessary) with a newline.

Note: Only `table` and `userdata` arguments are passed to
`logging.dump()`. Other arguments are passed to the built-in `tostring()`
function. This is partly an optimization and partly to prevent string arguments
from being quoted.

## logging.loglevel

Integer log level, which controls which of `logging.error()`, `logging.warning()`, `logging.info()` will generate output when called.

* `-2` : (or less) suppress all logging (apart from `logging.temp()`)
* `-1` : output only error messages
* `0` : output error and warning messages
* `1` : output error, warning and info messages
* `2` : output error, warning, info and debug messages
* `3` : (or more) output error, warning, info, debug and trace messages

The initial log level is `0`, unless the following pandoc command-line options are specified:

* `--trace` : `3` if `--verbose` is also specified; otherwise `2`
* `--verbose` : `1`
* `--quiet` : `-1`

## logging.setloglevel(loglevel)

Sets the log level and returns the previous level.

Calling this function is preferable to setting `logging.loglevel` directly.

## logging.error(...)

If the log level is >= `-1`, calls `logging.output()` with `(E)` and the supplied arguments.

## logging.warning(...)

If the log level is >= `0`, calls `logging.output()` with `(W)` and the supplied arguments.

## logging.info(...)

If the log level is >= `1`, calls `logging.output()` with `(I)` and the supplied arguments.

## logging.debug(...)

If the log level is >= `2`, calls `logging.output()` with `(D)` and the supplied arguments.

## logging.trace(...)

If the log level is >= `3`, calls `logging.output()` with `(T)` and the supplied arguments.

## logging.temp(...)

Unconditionally calls `logging.output()` with `(#)` and the supplied arguments.
