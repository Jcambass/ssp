# API

There are two general contexts where code run:

- **Build system:** The place you call [`processFile`](#processfile)/[`processString`](#processstring) from.
- **Metaprogram:** The file/Lua string being processed. (All examples on this page are in this context, unless noted otherwise.)

All global functions that are available to metaprograms are also available to the build system through the library:

```lua
-- Build system context:
local pp = require("preprocess") -- Examples on this page assume the library has been required into `pp`.
local luaString = pp.toLua("foo")

-- Metaprogram context:
!local luaString = toLua("foo")
```

- [Global functions in metaprograms](#global-functions-in-metaprograms)
  - [compareNatural](#comparenatural)
  - [concatTokens](#concattokens)
  - [copyTable](#copytable)
  - [eachToken](#eachtoken)
  - [escapePattern](#escapepattern)
  - [evaluate](#evaluate)
  - [fileExists](#fileexists)
  - [getFileContents](#getfilecontents) _(deprecated)_
  - [getIndentation](#getindentation)
  - [getNextUsefulToken](#getnextusefultoken)
  - [isProcessing](#isprocessing)
  - [isToken](#istoken)
  - [newToken](#newtoken)
  - [pack](#pack)
  - [pairsSorted](#pairssorted)
  - [printf](#printf)
  - [readFile](#readfile)
  - [removeUselessTokens](#removeuselesstokens)
  - [run](#run)
  - [serialize](#serialize)
  - [sortNatural](#sortnatural)
  - [tokenize](#tokenize)
  - [toLua](#tolua)
  - [unpack](#unpack)
  - [writeFile](#writefile)
- [Only during processing](#only-during-processing)
  - [callMacro](#callmacro)
  - [getCurrentIndentationInOutput](#getcurrentindentationinoutput)
  - [getCurrentLineNumberInOutput](#getcurrentlinenumberinoutput)
  - [getCurrentPathIn](#getcurrentpathin)
  - [getCurrentPathOut](#getcurrentpathout)
  - [getOutputSizeSoFar](#getoutputsizesofar)
  - [getOutputSoFar](#getoutputsofar)
  - [getOutputSoFarOnLine](#getoutputsofaronline)
  - [loadResource](#loadresource)
  - [outputLua](#outputlua)
  - [outputLuaTemplate](#outputluatemplate)
  - [outputValue](#outputvalue)
  - [startInterceptingOutput](#startinterceptingoutput)
  - [stopInterceptingOutput](#stopinterceptingoutput)
- [Macros](#macros)
  - [ASSERT](#assert) _(macro)_
  - [LOG](#log) _(macro)_
- [Exported stuff from the library](#exported-stuff-from-the-library)
  - (all the functions above)
  - [VERSION](#version)
  - [metaEnvironment](#metaenvironment)
  - [processFile](#processfile)
  - [processString](#processstring)

# Global functions in metaprograms

## compareNatural

```lua
aIsLessThanB = compareNatural( a, b )
```    

v1.18 Compare two strings. Numbers in the strings are compared as numbers (as opposed to as strings).

```lua
print(               "foo9" < "foo10" ) -- false
print(compareNatural("foo9",  "foo10")) -- true
```

See also: [sortNatural](#sortnatural)

## concatTokens

```lua
luaString = concatTokens( tokens )
```

v1.3 Concatenate tokens by their representations.

```lua
local tokens = {}

table.insert(tokens, newToken("identifier",  "foo"))
table.insert(tokens, newToken("punctuation", "="))
table.insert(tokens, newToken("string",      "bar"))

local luaString = concatTokens(tokens) -- foo="bar"
```

## copyTable

```lua
copy = copyTable( table [, deep=false ] )
```

v1.8 Copy a table, optionally recursively (deep copy). Multiple references to the same table and self-references are preserved during deep copying.

```lua
local t = {}
t[1]    = {s="foo"}
t.self  = t

local copy = copyTable(t, true)
assert(copy[1].s == "foo")
assert(copy.self == copy)
```

## eachToken

```lua
for index, token in eachToken( tokens [, ignoreUselessTokens=false ] ) do
```

v1.6 Loop through tokens.

## escapePattern
```lua
escapedString = escapePattern( string )
```

Escape a string so it can be used in a pattern as plain text.

```lua
local s = "2*5=10"
print(s:match("2*5"))                -- Matches "5"
print(s:match(escapePattern("2*5"))) -- Matches "2*5"
```

## evaluate

```lua
value = evaluate( expression )
value = evaluate( expression [, environment=getfenv() ] ) -- v1.19
```

v1.18 Evaluate a Lua expression. The function is kind of the opposite of [`toLua`](#tolua). Returns **nil** and a message on error.

Similar to calling `loadstring("return "..expression)()`.

> **Note:** **nil** or **false** can also be returned as the first value if that's the value the expression results in!

```lua
!(
print(evaluate("1+2")) -- 3

local function SCREAM(messageCode)
  local message = evaluate(messageCode):upper() .. "!!!"
  return "print(" .. toLua(message) .. ")"
end
)

@@SCREAM("Hello")

-- Output:
print("HELLO!!!")
```

## fileExists

```lua
bool = fileExists( path )
```

Check if a file exists (using [`io.open`](https://www.lua.org/manual/5.1/manual.html#pdf-io.open)).

## getFileContents

v1.19 Alias for [`readFile`](#readfile).

## getIndentation

```lua
string = getIndentation( line )
size   = getIndentation( line, tabWidth )
```

v1.19 Get indentation of a line, either as a string or as a size in spaces.

## getNextUsefulToken

```lua
token, index = getNextUsefulToken( tokens, startIndex [, steps=1 ] )
```

v1.7 Get the next token that isn't a whitespace or comment. Returns **nil** if no more tokens are found. Specify a negative steps value to get an earlier token.

## isProcessing

```lua
bool = isProcessing( )
```

v1.21 Returns **true** if a file or string is currently being [processed](#processfile).

## isToken

```lua
bool = isToken( token, tokenType [, tokenValue=any ] )
```

v1.6 Check if a token is of a specific type, optionally also check it's value.

```lua
local tokens = tokenize("local foo = 123")
local token1 = tokens[1]

if token1 and isToken(token1, "keyword", "if") then
  print("We got an if statement.")
end
```

## newToken

```lua
token = newToken( tokenType, ... )
```

v1.1 Create a new token. Different token types take different arguments.

```lua
commentToken     = newToken( "comment",     contents [, forceLongForm=false ] )
identifierToken  = newToken( "identifier",  identifier )
keywordToken     = newToken( "keyword",     keyword )
numberToken      = newToken( "number",      number [, numberFormat="auto" ] )
punctuationToken = newToken( "punctuation", symbol )
stringToken      = newToken( "string",      contents [, longForm=false ] )
whitespaceToken  = newToken( "whitespace",  contents )
ppEntryToken     = newToken( "pp_entry",    isDouble )
ppKeywordToken   = newToken( "pp_keyword",  ppKeyword ) -- ppKeyword can be "file", "insert", "line" or "@".
ppSymbolToken    = newToken( "pp_symbol",   identifier )


commentToken     = { type="comment",     representation=string, value=string, long=isLongForm }
identifierToken  = { type="identifier",  representation=string, value=string }
keywordToken     = { type="keyword",     representation=string, value=string }
numberToken      = { type="number",      representation=string, value=number }
punctuationToken = { type="punctuation", representation=string, value=string }
stringToken      = { type="string",      representation=string, value=string, long=isLongForm }
whitespaceToken  = { type="whitespace",  representation=string, value=string }
ppEntryToken     = { type="pp_entry",    representation=string, value=string, double=isDouble }
ppKeywordToken   = { type="pp_keyword",  representation=string, value=string }
ppSymbolToken    = { type="pp_symbol",   representation=string, value=string }
```

### Number formats

- `"int"` or `"integer"` (e.g. `42`)
- `"float"` (e.g. `3.14`)
- `"e"` or `"scientific"` (e.g. `0.7e+12`)
- `"E"` or `"SCIENTIFIC"` (e.g. `0.7E+12` (upper case))
- `"hex"` or `"hexadecimal"` (e.g. `0x19af`)
- `"HEX"` or `"HEXADECIMAL"` (e.g. `0x19AF` (upper case))
- `"auto"`

> **Note:** Infinite numbers and **NaN** always get automatic format:
> 
> - +Infinity: `(1/0)`
> - \-Infinity: `(-1/0)`
> - NaN: `(0/0)`

## pack

```lua
values = pack( value1, ... )
```

v1.8 Put values in a new array. `values.n` is the amount of values (which can be zero) including any **nil** values. Alias for [`table.pack`](https://www.lua.org/manual/5.2/manual.html#pdf-table.pack) in Lua 5.2+.

```lua
local function getValues()
  return 99, nil, "hello"
end

local values = pack(getValues())

print(#values)  -- Either 3 or 1 depending on interpreter implementation details. Unreliable!
print(values.n) -- 3

print(unpack(values, 1, values.n)) -- 99, nil, "hello"
```

## pairsSorted

```lua
for key, value in pairsSorted( table ) do
```

v1.18 Same as [`pairs`](https://www.lua.org/manual/5.1/manual.html#pdf-pairs) but the keys are sorted (ascending).

## printf

```lua
printf( formatString, value1, ... )
```

Print a formatted string. Same as `print(formatString:format(value1, ...))`.

## readFile

```lua
contents = readFile( path [, isTextFile=false ] )
```

v1.19 Get the entire contents of a binary file or text file (using [`io.open`](https://www.lua.org/manual/5.1/manual.html#pdf-io.open)). Returns **nil** and a message on error.

See also: [writeFile](#writefile)

## removeUselessTokens

```lua
removeUselessTokens( tokens )
```

v1.6 Remove whitespace and comment tokens.

## run

```lua
returnValue1, ... = run( path [, arg1, ... ] )
```

Execute a Lua file, optionally sending it extra arguments. Similar to [`dofile`](https://www.lua.org/manual/5.1/manual.html#pdf-dofile).

```lua
local docs = run("scripts/downloadDocumentation.lua", "perl")
```

## serialize

```lua
success, error = serialize( buffer, value )
```

Same as [`toLua`](#tolua) except adds the result to an array instead of returning the Lua code as a string. This could avoid allocating unnecessary strings.

```lua
local buffer = {}

table.insert(buffer, "local person = ")
serialize(buffer, {name="Barry", age=49})

local luaString = table.concat(buffer)
outputLua(luaString)
-- Output: local person = {age=49,name="Barry"}
```

## sortNatural

```lua
sortNatural( array )
```

v1.18 Sort an array using [`compareNatural`](#comparenatural).

## tokenize

```lua
tokens = tokenize( luaString [, allowPreprocessorCode=false ] )
```

v1.1 Convert Lua code to tokens. Returns **nil** and a message on error. See [`newToken`](#newtoken) for token fields and types. Additional token fields:

- `line`: Token start line number.
- `lineEnd`: Token end line number.
- `position`: Starting position in bytes.
- `file`: What file path the token came from.

## toLua

```lua
luaString = toLua( value )
```

Convert a value to a Lua literal. Does not work with certain types, like functions or userdata. Returns **nil** and a message on error.

```lua
local person    = {name="Barry", age=49}
local luaString = toLua(person)
outputLua("local person = ", luaString)
-- Output: local person = {age=49,name="Barry"}
```

## unpack

```lua
value1, ... = unpack( array [, fromIndex=1, toIndex=#array ] )
```

Is the normal [`unpack`](https://www.lua.org/manual/5.1/manual.html#pdf-unpack) in Lua 5.1 and alias for [`table.unpack`](https://www.lua.org/manual/5.2/manual.html#pdf-table.unpack) in Lua 5.2+.

## writeFile

```lua
success, error = writeFile( path, contents ) -- Writes a binary file.
success, error = writeFile( path, isTextFile, contents )
```

v1.19 Write an entire binary file or text file.

See also: [readFile](#readfile)

# Only during processing

## callMacro

```lua
luaString = callMacro( function , argument1, ... )
luaString = callMacro( macroName, argument1, ... )
```

v1.21 Call a macro function (which must be a global in [`metaEnvironment`](#metaenvironment) if `macroName` is given). The arguments should be Lua code strings. Outputted code from the macro is [captured](#startinterceptingoutput) and returned. Raises an error if no file or string is being processed.

See also: [@insert func()](extra-functionality.md#insert-func)

## getCurrentIndentationInOutput

```lua
string = getCurrentIndentationInOutput( )
size   = getCurrentIndentationInOutput( tabWidth )
```

v1.19 Get the indentation of the current line, either as a string or as a size in spaces. Raises an error if no file or string is being processed.

```lua
!(
local fooCode = [[
local x = 10 * i
foo(x)]]

function CALL_FOO()
  local indent = getCurrentIndentationInOutput()
  return fooCode:gsub("\n", "\n"..indent) -- Prepend indentation to all lines (except the first).
end
)

for i = 1, 3 do
  @@CALL_FOO()
end

-- Output (with correct indentation):
for i = 1, 3 do
  local x = 10 * i
  foo(x)
end
```

## getCurrentLineNumberInOutput

```lua
lineNumber = getCurrentLineNumberInOutput( )
```

v1.15 Get the current line number in the output. Raises an error if no file or string is being processed.

## getCurrentPathIn

```lua
path = getCurrentPathIn( )
```

v1.8 Get what file is currently being processed, if any.

## getCurrentPathOut

```lua
path = getCurrentPathOut( )
```

v1.8 Get what file the currently processed file will be written to, if any.

## getOutputSizeSoFar

```lua
size = getOutputSizeSoFar( )
```

v1.15 Get the amount of bytes outputted so far. Raises an error if no file or string is being processed.

## getOutputSoFar

```lua
luaString = getOutputSoFar( [ asTable=false ] )
getOutputSoFar( buffer ) -- v1.20
```

v1.15 Get Lua code that's been outputted so far. Raises an error if no file or string is being processed.

- If `asTable` is **false** then the full Lua code string is returned.
- If `asTable` is **true** then an array of Lua code segments is returned. (This avoids allocating, possibly large, strings.)
- v1.20 If a `buffer` array is given then Lua code segments are added to it.

## getOutputSoFarOnLine

```lua
luaString = getOutputSoFarOnLine( )
```

v1.19 Get Lua code that's been outputted so far on the current line. Raises an error if no file or string is being processed.

## loadResource

```lua
luaString = loadResource( name )
```

v1.18 Load a Lua file/resource (using the same mechanism as [`@insert "name"`](extra-functionality.md#insert-name)). Note that resources are cached after loading once. Raises an error if no file or string is being processed.

## outputLua

```lua
outputLua( luaString1, ... )
```

Output one or more strings as raw Lua code. Raises an error if no file or string is being processed.

```lua
local funcName = "doNothing"
outputLua("local function ", funcName, "()\n")
outputLua("end\n")
```

> **Note:** Generated metaprograms will contain calls to `__LUA()` which is an alias of `outputLua()`.

## outputLuaTemplate

```lua
outputLuaTemplate( luaStringTemplate, value1, ... )
```

v1.10 Use a string as a template for outputting Lua code with values. Question marks (`?`) are replaced with the values. Raises an error if no file or string is being processed.

```lua
outputLuaTemplate("local name, age = ?, ?", "Harry", 48)
outputLuaTemplate("dogs[?] = ?", "greyhound", {italian=false, count=5})

-- Output:
local name, age = "Harry", 48
dogs["greyhound"] = {count=5,italian=false}
```

## outputValue

```lua
outputValue( value )
outputValue( value1, value2, ... )
```

Output one or more values, like strings or tables, as literals. If multiple values are specified then the values will be separated by commas. Cannot output functions or userdata. Raises an error if no file or string is being processed.

```lua
outputLua("local person = ")
outputValue({ name="Barry", age=49 })
```

> **Note:** Generated metaprograms will contain calls to `__VAL` which is an alias of `outputValue`.

## startInterceptingOutput

```lua
startInterceptingOutput( )
```

Start intercepting output until [`stopInterceptingOutput`](#stopinterceptingoutput) is called. The function can be called multiple times to intercept interceptions. Raises an error if no file or string is being processed.

```lua
startInterceptingOutput()

outputLua("local dog = ")
outputValue("good boy")

local luaString = stopInterceptingOutput()
luaString       = luaString:gsub("dog", "cat")
outputLua(luaString) -- Output: local cat = "good boy"
```

## stopInterceptingOutput

```lua
luaString = stopInterceptingOutput( )
```

Stop intercepting output and retrieve collected code. See [`startInterceptingOutput`](#startinterceptingoutput) for example usage. Raises an error if no file or string is being processed.

# Macros

## ASSERT

```lua
@@ASSERT( condition [, message=auto ] )
```

Macro v1.17 Does nothing if [`params.release`](#processfile) is set, otherwise outputs code that calls [`error`](https://www.lua.org/manual/5.1/manual.html#pdf-error) if the condition fails. The message argument is only evaluated if the condition fails.

```lua
-- In file to be processed:
local name = generateRandomName()
@@ASSERT(name ~= "")
@@ASSERT(#name > 5, "Name is too short: "..name)
```

## LOG

```lua
@@LOG( logLevel, value ) -- [1]
@@LOG( logLevel, format, value1, ... ) -- [2]
```

Macro v1.17 Does nothing if `logLevel` is lower than [`params.logLevel`](#processfile), otherwise outputs code that prints a value\[1\] or a formatted message\[2\].

`logLevel` can be `"error"`, `"warning"`, `"info"`, `"debug"` or `"trace"` (from highest to lowest priority).

```lua
-- In file to be processed:
local function oldAdd(x, y)
  @@LOG("warning", "oldAdd() is deprecated - use newAdd() instead!")
  return x + y
end
```

# Exported stuff from the library

All global functions that are available to metaprograms are also here (like [`readFile`](#readFile) etc.).

## VERSION

```lua
pp.VERSION
```

The version of LuaPreprocess, e.g. `"1.12.0"`.

## metaEnvironment

```lua
pp.metaEnvironment
```

The [environment](https://www.lua.org/manual/5.1/manual.html#2.9) used for metaprograms (and the message handler in the command line program). The table is a shallow copy of the global environment.

```lua
-- Build system context:
pp.metaEnvironment.theValue = "Hello"

-- Metaprogram context:
!print(theValue) -- Hello
```

## processFile

```lua
processedFileInfo = pp.processFile( params )
```

Process a Lua file. Returns **nil** and a message on error.

- `processedFileInfo`: Table with various information (see [`processedFileInfo`](#processedfileinfo)).
- `params`: Table with the following fields:

```lua
pathIn               = pathToInputFile       -- [Required]
pathOut              = pathToOutputFile      -- [Required]
pathMeta             = pathForMetaprogram    -- [Optional] You can inspect this temporary output file if an error occurs in the metaprogram.

debug                = boolean               -- [Optional] Debug mode. The metaprogram file is formatted more nicely and does not get deleted automatically.
addLineNumbers       = boolean               -- [Optional] Add comments with line numbers to the output.

backtickStrings      = boolean               -- [Optional] Enable the backtick (`) to be used as string literal delimiters. Backtick strings don't interpret any escape sequences and can't contain backticks. (Default: false)
jitSyntax            = boolean               -- [Optional] Allow LuaJIT-specific syntax. (Default: false)
canOutputNil         = boolean               -- [Optional] Allow !(expression) and outputValue() to output nil. (Default: true)
fastStrings          = boolean               -- [Optional] Force fast serialization of string values. (Non-ASCII characters will look ugly.) (Default: false)
validate             = boolean               -- [Optional] Validate output. (Default: true)
strictMacroArguments = boolean               -- [Optional] Check that macro arguments are valid Lua expressions. (Default: true)

macroPrefix          = prefix                -- [Optional] String to prepend to macro names. (Default: "")
macroSuffix          = suffix                -- [Optional] String to append  to macro names. (Default: "")

release              = boolean               -- [Optional] Enable release mode. Currently only disables the @@ASSERT() macro when true. (Default: false)
logLevel             = levelName             -- [Optional] Maximum log level for the @@LOG() macro. Can be "off", "error", "warning", "info", "debug" or "trace". (Default: "trace", which enables all logging)

onInsert             = function( name )      -- [Optional] Called for each @insert"name" instruction. It's expected to return a Lua code string. By default 'name' is a path to a file to be inserted.
onBeforeMeta         = function( luaString ) -- [Optional] Called before the metaprogram runs, if a metaprogram was generated. luaString contains the metaprogram.
onAfterMeta          = function( luaString ) -- [Optional] Here you can modify and return the Lua code before it's written to 'pathOut'.
onError              = function( error )     -- [Optional] You can use this to get traceback information. 'error' is the same value as what is returned from processFile().
```

## processString

```lua
luaString, processedFileInfo = pp.processString( params )
```

v1.2 Process Lua code. Returns **nil** and a message on error.

- `luaString`: The processed Lua code.
- `processedFileInfo`: Table with various information (see [`processedFileInfo`](#processedfileinfo)).
- `params`: Table with the following fields:

```lua
code                 = luaString             -- [Required]
pathMeta             = pathForMetaprogram    -- [Optional] You can inspect this temporary output file if an error occurs in the metaprogram.

debug                = boolean               -- [Optional] Debug mode. The metaprogram file is formatted more nicely and does not get deleted automatically.
addLineNumbers       = boolean               -- [Optional] Add comments with line numbers to the output.

backtickStrings      = boolean               -- [Optional] Enable the backtick (`) to be used as string literal delimiters. Backtick strings don't interpret any escape sequences and can't contain backticks. (Default: false)
jitSyntax            = boolean               -- [Optional] Allow LuaJIT-specific syntax. (Default: false)
canOutputNil         = boolean               -- [Optional] Allow !(expression) and outputValue() to output nil. (Default: true)
fastStrings          = boolean               -- [Optional] Force fast serialization of string values. (Non-ASCII characters will look ugly.) (Default: false)
validate             = boolean               -- [Optional] Validate output. (Default: true)
strictMacroArguments = boolean               -- [Optional] Check that macro arguments are valid Lua expressions. (Default: true)

macroPrefix          = prefix                -- [Optional] String to prepend to macro names. (Default: "")
macroSuffix          = suffix                -- [Optional] String to append  to macro names. (Default: "")

release              = boolean               -- [Optional] Enable release mode. Currently only disables the @@ASSERT() macro when true. (Default: false)
logLevel             = levelName             -- [Optional] Maximum log level for the @@LOG() macro. Can be "off", "error", "warning", "info", "debug" or "trace". (Default: "trace", which enables all logging)

onInsert             = function( name )      -- [Optional] Called for each @insert"name" instruction. It's expected to return a Lua code string. By default 'name' is a path to a file to be inserted.
onBeforeMeta         = function( luaString ) -- [Optional] Called before the metaprogram runs, if a metaprogram was generated. luaString contains the metaprogram.
onError              = function( error )     -- [Optional] You can use this to get traceback information. 'error' is the same value as the second returned value from processString().
```

# Other info

## processedFileInfo

Table returned from [`processFile`](#processfile) and [`processString`](#processstring) (and sent to the [`"filedone"`](command-line.md#filedone) message handler in the command line program). Contains these fields:

- `path`: Path to the processed file. (Empty if [`processString`](#processstring) was used.)
- `outputPath`: v1.9 Path to the outputted file. (Empty if [`processString`](#processstring) was used.)
- `processedByteCount`: The length of the processed data in bytes.
- `lineCount`: Total line count.
- `linesOfCode`: v1.3 Amount of lines with code.
- `tokenCount`: Total token count.
- `hasPreprocessorCode`: Whether any preprocessor code was encountered. If this is **false** then the file is 100% pure Lua.
- `hasMetaprogram`: v1.13 Whether any preprocessor code that triggered code execution was encountered.
- `insertedFiles`: v1.10 Array of names to resources inserted by [`@insert "name"`](extra-functionality.md#insert-name) instructions.