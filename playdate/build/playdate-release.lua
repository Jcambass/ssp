local build = require("playbit.build")

build.build({ 
  assert = false,
  debug = false,
  platform = "playdate",
  output = "_pdx\\",
  clearBuildFolder = true,
  fileProcessors = {
    lua = build.luaProcessor,
    wav = build.waveProcessor,
    aseprite = build.skipFile,
  },
  files = {
    -- essential playbit files for playdate
    { "playbit/playbit", "playbit" },
    -- project
    { "Source/main.lua", "main.lua" },
    { "Source/consts.lua", "consts.lua" },
    { "Source/healthBar.lua", "healthBar.lua" },
    { "Source/highscore.lua", "highscore.lua" },
    { "Source/sceneManager.lua", "sceneManager.lua" },
    { "Source/screenShake.lua", "screenShake.lua" },
    { "Source/signal.lua", "signal.lua" },
    { "Source/actors", "actors" },
    { "Source/animations", "animations" },
    { "Source/background", "background" },
    { "Source/scenes", "scenes" },
    { "Source/ui", "ui" },
    { "Source/weapons", "weapons" },
    { "Source/Images", "Images" },
    { "Source/SystemAssets", "SystemAssets" },
    { "Source/metadata.json", "pdxinfo",
      {
        json = { build.pdxinfoProcessor, { incrementBuildNumber = true } }
      }
    }
  },
})