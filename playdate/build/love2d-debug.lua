local build = require("playbit.build")

build.build({ 
  assert = true,
  debug = true,
  platform = "love2d",
  output = "_love2d",
  clearBuildFolder = true,
  fileProcessors = {
    lua = build.luaProcessor,
    fnt = build.fntProcessor,
    aseprite = build.skipFile,
  },
  files = {
    -- essential playbit files for love2d
    { "playbit/conf.lua", "conf.lua" },
    { "playbit/playbit", "playbit" },
    { "playbit/playdate", "playdate" },
    { "playbit/json/json.lua", "json/json.lua" },
    { "playbit/fonts", "fonts" },
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
        json = { build.pdxinfoProcessor, { incrementBuildNumber = false } }
      }
    }
  },
})