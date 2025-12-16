# How to metaprogram

The exclamation mark (!) is used to indicate what code is part of the metaprogram. There are 4 main ways to write metaprogram code:

- `!...` - One exclamation mark - run a line of code.
- `!!...` - Two exclamation marks - output code to both the metaprogram and final program.
- `!( ... )` - One exclamation mark followed by parenthesis - output a value, or run a block of code.
- `!!( ... )` - Two exclamation marks followed by parenthesis - output lua code.

## _!..._

The line will simply run during preprocessing. The line can span multiple physical lines if it contains brackets.

```lua
-- Simple preprocessor lines.
!if not isDeveloper then
  sendTelemetry()
!end

-- Span multiple lines.
!newClass{
  name  = "Entity",
  props = {x=0, y=0},
}

-- There can be stuff before a preprocessor line.
local foo = 10  !print("We've reached foo.")

-- Example output:
sendTelemetry()

function newEntity()
  return {__classname="Entity", x=0, y=0}
end

local foo = 10
```

## _!!..._

The line will appear in both the metaprogram and the final program. The line must be an assignment (and optionally a declaration). The value will be evaluated in the metaprogram.

```lua
-- The expression will be evaluated in the metaprogram and the
-- result will appear in the final program as a literal value.
!!local tau     = 2 * math.pi
!!local aAndTau = ("a"):rep(10) .. tau

-- Output:
local tau     = 6.283185
local aAndTau = "aaaaaaaaaa6.283185"
```

These two code snippets are equivalent:

```lua
!!local x = foo()

!local x = foo()
local x = !(x)
```

## _!( ... )_

If the parenthesis contains an expression the result of the expression will be outputted as a literal value, otherwise the code will just run as-is.

```lua
-- Output values.
local bigNumber = !( 5^10 )
local manyAbcs  = !( ("abc"):rep(10) )

-- Run a block of code.
!(
local dogWord = "Woof "
function getDogText()
  return dogWord:rep(3)
end
outputLua("dog = ")
outputValue(getDogText())
)

-- Output:
local bigNumber = 9765625
local manyAbcs  = "abcabcabcabcabcabcabcabcabcabc"

dog = "Woof Woof Woof "
```

## _!!( ... )_

The result of the expression in the parenthesis will be outputted as Lua code. The result must be a string value.

```lua
local font = !!( isDeveloper and "loadDevFont()" or "loadUserFont()" )

!local globals = {pi=math.pi, tau=2*math.pi}
!for k, v in pairs(globals) do
  _G.!!(k) = !(v)
!end

-- Example output:
local font = loadUserFont()

_G.pi  = 3.14159265358979323846
_G.tau = 6.28318530717958647693
```

(Also see [macros](extra-functionality.md#insert-func) and [symbols](extra-functionality.md#preprocessor-symbols).)

# Two ways of generating code

These examples show two ways of doing the same thing using inline code and a code block.

## Populate a table

```lua
-- Using inline code.
local oddNumbers = {
  !for v = 1, 5, 2 do
    !( v ),
  !end
}

-- Using a code block.
!(
outputLua("local oddNumbers = {\n")
for v = 1, 5, 2 do
  outputLua("\t")
  outputValue(v)
  outputLua(",\n")
end
outputLua("}")
)

-- Output:
local oddNumbers = {
  1,
  3,
  5,
}
```

## Generate a pattern

```lua
-- Using inline code.
!local alpha        = "[%a_]"
!local alphaNumeric = "[%w_]"
local identifierPattern = !( "^"..alpha..alphaNumeric.."*$" )

-- Using a code block.
!(
local alpha        = "[%a_]"
local alphaNumeric = "[%w_]"
outputLua("local identifierPattern = ")
outputValue("^"..alpha..alphaNumeric.."*$")
)

-- Output:
local identifierPattern = "^[%a_][%w_]*$"
```

# Potential gotchas

Beware in code blocks that only call a single function:

```lua
-- This will bee seen as an inline block and output whatever value
-- func() returns as a literal.
!( func() )

-- If that's not wanted then a trailing ";" will prevent that.
-- This line won't output anything (unless func() calls outputLua()
-- or outputValue()).
!( func(); )

-- When the full metaprogram is generated, `!(func())` translates
-- into `outputValue(func())` while `!(func();)` simply translates
-- into `func();` (because `outputValue(func();)` would be invalid
-- Lua code).

-- Anyway, in this specific case a preprocessor line (without the
-- parenthesis) would be nicer:
!func()
```