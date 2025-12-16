# Command line

- [Command line usage](#command-line-usage)
  - [Examples](#examples)
- [Options](#options)
- [Message handlers](#message-handlers)
- [Messages](#messages)
- [Other info](#other-info)

## Command line usage

Values inside square brackets (`[]`) are optional.

**Windows:**

```
Preprocess.cmd [options] [--] filepath1 [filepath2 ...]
OR
Preprocess.cmd --outputpaths [options] [--] inputpath1 outputpath1 [inputpath2 outputpath2 ...]
```

**Any system:**

```
lua preprocess-cl.lua [options] [--] filepath1 [filepath2 ...]
OR
lua preprocess-cl.lua --outputpaths [options] [--] inputpath1 outputpath1 [inputpath2 outputpath2 ...]
```

**Exit codes:**

- `0`: The script executed successfully.
- `1`: An error happened.

### Examples

```
lua preprocess-cl.lua --saveinfo=logs/info.lua --silent src/main.lua2p src/network.lua2p
lua preprocess-cl.lua --debug src/main.lua2p src/network.lua2p
lua preprocess-cl.lua --outputpaths --linenumbers  src/main.lua2p output/main.lua  src/network.lua2p output/network.lua
```

# Options

- [--backtickstrings](#backtickstrings)
- [--data](#data)
- [--faststrings](#faststrings)
- [--handler](#handler)
- [--help](#help)
- [--jitsyntax](#jitsyntax)
- [--linenumbers](#linenumbers)
- [--loglevel](#loglevel)
- [--macroprefix](#macroprefix)
- [--macrosuffix](#macrosuffix)
- [--meta](#meta)
- [--nogc](#nogc)
- [--nonil](#nonil)
- [--nostrictmacroarguments](#nostrictmacroarguments)
- [--novalidate](#novalidate)
- [--outputextension](#outputextension)
- [--outputpaths](#outputpaths)
- [--release](#release)
- [--saveinfo](#saveinfo)
- [--silent](#silent)
- [--version](#version)
- [--debug](#debug)
- [--](#dash-dash)

## --backtickstrings

`--backtickstrings`

v1.11.2 Enable [backtick strings](extra-functionality.md#backtick-strings).

## --data

`--data="Any data."` or `-d="Any data."`

v1.9 A string with any data. If this option is present then the value will be available through the global `dataFromCommandLine` in the processed files (and any message handler). Otherwise, `dataFromCommandLine` is **nil**.

## --faststrings

`--faststrings`

v1.13.1 Force fast serialization of string values. (Non-ASCII characters will look ugly.)

## --handler

`--handler=pathToMessageHandler` or `-h=pathToMessageHandler`

Path to a Lua file that's expected to return a function, or a table of functions, that handles messages. (See [Message Handlers](#message-handlers) and [Messages](#messages) for more info.)

## --help

`--help`

v1.20 Print the command line help topics.

## --jitsyntax

`--jitsyntax`

v1.12 Allow [LuaJIT-specific syntax](https://luajit.org/ext_ffi_api.html#literals), specifically literals for 64-bit integers (`42LL`, `0x2aULL`), complex numbers (`12.5i`) and binary numbers (`0b110010`).

## --linenumbers

`--linenumbers`

Add comments with line numbers to the output.

## --loglevel

`--loglevel=levelName`

v1.17 Set maximum log level for the [`LOG`](api.md#log) macro. Can be `"off"`, `"error"`, `"warning"`, `"info"`, `"debug"` or `"trace"`. The default is `"trace"`, which enables all logging.

## --macroprefix

`--macroprefix=prefix`

v1.17 String to prepend to macro names (e.g. make `@@FOO()` call the function `MACRO_FOO()`).

## --macrosuffix

`--macrosuffix=suffix`

v1.17 String to append to macro names.

## --meta

`--meta`  
`--meta=pathToSaveMetaprogramTo` v1.20

v1.2 Output the metaprogram to a temporary file (`*.meta.lua`), if a metaprogram is generated. This is useful if an error happens when the metaprogram runs. The file is removed if there's no error and [`--debug`](#debug) isn't enabled.

## --nogc

`--nogc`

v1.14.1 Stop the garbage collector. Same as calling `collectgarbage("stop")`. This may speed up the preprocessing.

## --nonil

`--nonil`

v1.11.2 Disallow `!(expression)` and [`outputValue()`](api.md#outputvalue) from outputting **nil**.

## --nostrictmacroarguments

`--nostrictmacroarguments`

v1.21 Disable checks that macro arguments are valid Lua expressions.

## --novalidate

`--novalidate`

v1.12 Disable validation of outputted Lua.

## --outputextension

`--outputextension=fileExtension`

Specify what file extension generated files should have. The default extension is `"lua"`. If any input files end with `.lua` then you must specify another file extension with this option (or use [`--outputpaths`](#outputpaths)).

> It's suggested that you use `.lua2p` (as in "Lua To Process") as extension for unprocessed files.

## --outputpaths

`--outputpaths` or `-o`

v1.9 This flag makes every other specified path be the output path for the previous path. Example:

```
lua preprocess-cl.lua --outputpaths  src/main.lua2p output/main.lua  src/network.lua2p output/network.lua
```

## --release

`--release`

v1.17 Enable release mode. Currently only disables the [`ASSERT`](api.md#assert) macro.

## --saveinfo

`--saveinfo=pathToSaveProcessingInfoTo` or `-i=pathToSaveProcessingInfoTo`

Processing information includes what files had any preprocessor code in them, and things like that. The format of the file is a Lua module that returns [`processingInfo`](#processinginfo).

## --silent

`--silent`

Only print errors to the console.

## --version

`--version`

v1.20 Print the version of LuaPreprocess to `stdout` and exit.

## --debug

`--debug`

Enable some preprocessing debug features. Useful if you want to inspect the metaprogram (`*.meta.lua`) if one is generated. (This also enables the [`--meta`](#meta) option.)

## --

`--`

Stop options from being parsed further. Needed if you have paths starting with `"-"`.

# Message handlers

Messages are sent when events happen, for example before a metaprogram runs or after the output has been written to file.

There are two ways of catching and handling messages (in the file specified by [`--handler`](#handler)) - either by returning a function or a table. If the file returns a _function_ then it will be called with various [messages](#messages) as its first argument. If the file returns a _table_, the keys should be the [message names](#messages) and the values should be functions to handle the respective message. (See below.)

The file shares the same environment as the processed files, making it a good place to put things all files use/share in their metaprogram (i.e. global functions and other values).

## Using multiple specific message handlers

```lua
-- messageHandler.lua
return {
  beforemeta = function(path)
    print("... Now processing "..path)
  end,

  aftermeta = function(path, luaString)
    -- Remove comments (quick and dirty).
    luaString = luaString
      :gsub("%-%-%[%[.-%]%]", "") -- Multi-line.
      :gsub("%-%-[^\n]*",     "") -- Single line.

    return luaString
  end,

  filedone = function(path, outputPath)
    print("... Done with "..path.." (writing to "..outputPath..")")
  end,
}
```

## Using a single catch-all message handler

```lua
-- messageHandler.lua
return function(message, ...)
  if message == "beforemeta" then
    local path = ...
    print("... Now processing "..path)

  elseif message == "aftermeta" then
    local path, luaString = ...

    -- Remove comments (quick and dirty).
    luaString = luaString
      :gsub("%-%-%[%[.-%]%]", "") -- Multi-line.
      :gsub("%-%-[^\n]*",     "") -- Single line.

    return luaString

  elseif message == "filedone" then
    local path, outputPath = ...
    print("... Done with "..path.." (writing to "..outputPath..")")
  end
end
```

# Messages

- ["init"](#init)
- ["insert"](#insert)
- ["beforemeta"](#beforemeta)
- ["aftermeta"](#aftermeta)
- ["filedone"](#filedone)
- ["fileerror"](#fileerror)
- ["alldone"](#alldone)

## "init"

Sent before any other message.

Arguments:

- `inputPaths`: Array of file paths to process. Paths can be added or removed freely.
- `outputPaths`: If the [`--outputpaths`](#outputpaths) option is present this is an array of output paths for the respective path in `inputPaths`, otherwise it's **nil**.

## "insert"

v1.11 Sent for each [`@insert "name"`](extra-functionality.md#insert-name) instruction. The handler is expected to return a Lua code string.

Arguments:

- `path`: The file being processed.
- `name`: The name of the resource to be inserted (could be a file path or anything).

## "beforemeta"

Sent before a file's metaprogram runs, if a metaprogram was generated.

Arguments:

- `path`: The file being processed.
- `luaString`: v1.21 The generated metaprogram.

## "aftermeta"

Sent after a file's metaprogram has produced output (before the output is written to a file).

Arguments:

- `path`: The file being processed.
- `luaString`: The produced Lua code. You can modify this and return the modified string.

## "filedone"

Sent after a file has finished processing and the output written to file.

Arguments:

- `path`: The file being processed.
- `outputPath`: Where the output of the metaprogram was written.
- `info`: [`processedFileInfo`](api.md#processedfileinfo).

## "fileerror"

Sent if an error happens while processing a file (right before the program exits).

Arguments:

- `path`: The file being processed.
- `error`: The error message.

## "alldone"

v1.20 Sent after all other messages (right before the program exits).

Arguments:

- (none)

# Other info

## processingInfo

Table saved by the [`--saveinfo`](#saveinfo) option. Contains these fields:

- `date`: Datetime string of when the preprocessing began, e.g. `"2019-05-21 15:28:34"`.
- `files`: Array of [`processedFileInfo`](api.md#processedfileinfo).