# Extra functionality

- [Preprocessor keywords](#preprocessor-keywords)
- [Preprocessor symbols](#preprocessor-symbols)
- [Backtick strings](#backtick-strings)

* * *

Preprocessor keywords[](#preprocessor-keywords)
-----------------------------------------------

In addition to the exclamation mark (`!`) there is another symbol with special meaning in LuaPreprocess: the at sign (`@`). It's used as prefix for a few special preprocessor keywords that do different things.

- [@file](#file)
- [@line](#line)
- [@insert](#insert)
  - [@insert "name"](#insert-name)
  - [@insert func()](#insert-func) _(macros)_

## @file

v1.11 Inserts the path to the current file as a string literal, e.g. `"src/scenes/main.lua2p"`.

```lua
print("Current file: "..@file)

-- Example output:
print("Current file: ".."src/scenes/main.lua2p")
```

## @line

v1.11 Inserts the current line number as an integer numeral.

```lua
print("Current line: "..@line)

-- Example output:
print("Current line: ".. 372)
```

## @insert

This keyword has two variants.

### @insert "name"

v1.10 This variant inserts a _resource_ as-is in-place before the metaprogram runs (the resource being a Lua code string from somewhere). By default, `name` is a path to a file to be inserted but this behavior can be changed by defining `params.onInsert()` when calling [`processFile`](api.md#processfile) or [`processString`](api.md#processstring) (or by handling the [`"insert"`](command-line.md#insert) message in the message handler in the command line program).

```lua
-- script.lua
local one = 1
@insert "partialScript.lua"
print(one + two)

-- partialScript.lua
local two = !( 1+1 )

-- Output:
local one = 1
local two = 2
print(one + two)
```

The keyword can also appear in the metaprogram anywhere.

```lua
-- script.lua
!(
@insert "yellFunction.lua"
yell("aaargh")
)
local versionText = !( "Version: " .. @insert "appVersion.txt" )
print(versionText) -- Version: 1.2.3

-- yellFunction.lua
local function yell(text)
  print(text:upper().."!!!")
end

-- appVersion.txt
"1.2.3"
```

v1.13 `@insert` can also be written more compactly as `@@`:

```lua
@@"yellFunction.lua"
```

### @insert func()

v1.13 This variant outputs the result returned from a function `func()` defined in the metaprogram (like `!!(func())`) except all arguments are converted to individual strings containing the apparent Lua code before the call. We call these macros (similar to macros in C/C++ and other languages).

```lua
-- Define a better assert function.

!(
local DEBUG = true

local function ASSERT(conditionCode, messageCode)
  if not DEBUG then
    -- Make ASSERT() calls do nothing if we're not in debug mode.
    return ""
  end
  if not messageCode then
    messageCode = string.format("%q", "Assertion failed: "..conditionCode)
  end
  return "if not ("..conditionCode..") then error("..messageCode..") end"
end
)

local text = "Herzlich willkommen!"
@insert ASSERT(#text < 15, "Text is too long: "..text)

-- Output:
local text = "Herzlich willkommen!"
if not (#text < 15) then error("Text is too long: "..text) end
```

> Note: An [`ASSERT`](api.md#assert) macro is already provided by the library.

`@insert` can also be written more compactly as `@@`:

```lua
@@ASSERT(#text < 15, "Text is too long: "..text)
```

> `@@ASSERT` kind of looks like a preprocessor keyword here, so we could call it a user-defined preprocessor keyword if we wanted to (even though it's not actually a keyword).

v1.14 `!(expression)` and `!!(expression)` work in macros. Note that code blocks in macros do not output anything themselves - instead, their result is concatenated with the surrounding Lua code to be part of the argument for the macro function.

Macros can also be nested.

```lua
!local variableName = "text"
!local maxLength    = 3*5

@@ASSERT(
  #!!(variableName) < !(maxLength),
  @@string.upper("Text is too long: ") .. !!(variableName)
)

-- Output:
local text = "Herzlich willkommen!"
if not (#text < 15) then error("TEXT IS TOO LONG: " .. text) end
```

Note that `string.upper` receives `"\"Text is too long: \""` here, i.e. a Lua code string, but it works because the function doesn't change the quote characters.

These are all the forms macros can have:

```lua
@@func()    -- Syntax sugar for @insert func()
@@func{}    -- Syntax sugar for @@func({})
@@func""    -- Syntax sugar for @@func("")
@@func!(e)  -- Syntax sugar for @@func(!(e))
@@func!!(e) -- Syntax sugar for @@func(!!(e)) - this is functionally the same as !!(func(e))
```

v1.16 Macro functions can choose whether to return a Lua code string or use [`outputLua`](api.md#outputlua) (and related functions).

```lua
!(
local function DOG_1()
  return "getDog()"
end
local function DOG_2()
  outputLua("getDog()")
end
)
-- The result for these two lines are the same:
local dog = @@DOG_1()
local dog = @@DOG_2()

-- Output:
local dog = getDog()
local dog = getDog()


-- Combining both methods raises an error.
!(
local function DOG_3()
  outputLua("getDog()")
  return "getDog()"
end
)
local dog = @@DOG_3() -- Error!
```

v1.19 Any other use of `!` also works in macros.

```lua
!(
local function ONE_TWO_ONE(one, two)
  return one .. two .. one
end
)
@@ONE_TWO_ONE(
  !outputLua("bark()") -- The output is captured by the macro's 1st argument.
  ,
  !outputLua("meow()") -- The output is captured by the macro's 2nd argument.
)

-- Output:
bark()
meow()
bark()
```

See also: [callMacro](api.md#callmacro)

# Preprocessor symbols

v1.16 Preprocessor symbols output Lua code similarly to `!!(expression)`. A symbol is a dollar sign (`$`) followed by a name referencing a variable in the metaprogram.

```lua
!local EXPRESSION = "5*getFoo()"
-- These two lines are equivalent:
local x = $EXPRESSION
local x = !!(EXPRESSION)

-- Output:
local x = 5*getFoo()
local x = 5*getFoo()
```

A difference from `!!(expression)` is that if the name references a function (v1.18 or callable table) then the function (or table) is called.

```lua
!(
local count = 0
local function NEW_ID()
  count = count + 1
  return toLua(count)
end
)
local someId  = $NEW_ID
local otherId = $NEW_ID

-- Output:
local someId  = 1
local otherId = 2
```

Preprocessor symbols and macros can work very well together.

```lua
!local function ADD_IF_SINGLE_DIGIT(variable, value)
  if $variable <= 9 then
    $variable = $variable + $value
  end
!end

local x = 0
@@ADD_IF_SINGLE_DIGIT(x, 100)

-- Output:
local x = 0
if x <= 9 then
  x = x + 100
end
```

Note how the body of the `ADD_IF_SINGLE_DIGIT` function is not part of the metaprogram (except for the `$variable` and `$value` symbols). We could write the same function like this:

```lua
!(
local function ADD_IF_SINGLE_DIGIT(variable, value)
  outputLua("if ",variable," <= 9 then\n")
  outputLua("\t",variable," = ",variable," + ",value,"\n")
  outputLua("end\n")
end
)
```

# Backtick strings

The [`backtickStrings` parameter](api.md#processfile) (or [`--backtickstrings` option](command-line.md#backtickstrings)) enables the backtick (`` ` ``) to be used as string literal delimiters. Backtick strings don't interpret any escape sequences and can't contain other backticks. The strings can span multiple lines.

This feature can be nice for strings that contain Lua code and you want your text editor to apply normal syntax highlighting to the string contents. Example:

```lua
!local DOUBLE_X = `
  x = x*2
`
local x = 1
$DOUBLE_X
$DOUBLE_X
print(x)

-- Output:
local x = 1
x = x*2
x = x*2
print(x)
```
