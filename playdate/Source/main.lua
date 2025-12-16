-- Name this file `main.lua`. Your game can use multiple source files if you wish
-- (use the `import "myFilename"` command), but the simplest games can be written
-- with just `main.lua`.

-- You'll want to import these in just about every project you'll work on.

@@"playbit/header.lua"

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "consts"
import "actors/player"
import "sceneManager"
import "scenes/startScene"
import "signal"
import "highScore"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local leaderboardImage = gfx.image.new("Images/leaderboard")
assert(leaderboardImage) -- make sure the image was where we thought

function setupMenuImage()
  local highScores = GetHighScores()
  local img = leaderboardImage:copy()
  gfx.pushContext(img)
    gfx.setColor(gfx.kColorBlack)

    if highScores[1].score ~= 0 then
      gfx.drawText(highScores[1].name .. ": " .. highScores[1].score, 60, 60)
    end
    if highScores[2].score ~= 0 then
      gfx.drawText(highScores[2].name .. ": " .. highScores[2].score, 60, 108)
    end
    if highScores[3].score ~= 0 then
      gfx.drawText(highScores[3].name .. ": " .. highScores[3].score, 60, 157)
    end

  gfx.popContext()

  pd.setMenuImage(img)
end

function setupGame()
  gfx.setBackgroundColor(playdate.graphics.kColorBlack)
  gfx.setImageDrawMode(gfx.kDrawModeInverted)
  pd.display.setRefreshRate(50)

  math.randomseed(pd.getSecondsSinceEpoch())

  -- This is needed even if we don't do anything. Otherwise the background will be weird.
  gfx.sprite.setBackgroundDrawingCallback(
    function(x, y, width, height)
      -- x,y,width,height is the updated area in sprite-local coordinates
      -- The clip rect is already set to this area, so we don't need to set it ourselves

      -- do nothing for now.
    end
  )

  setupMenuImage()
end

-- Note: Do not rely on `NOTIFICATION_CENTER` outside of a scene context.
-- Switching scenes will clear all subscriptions.
NOTIFICATION_CENTER = Signal()
SCENE_MANAGER = SceneManager()

setupGame()
StartScene()

function playdate.update()
  gfx.sprite.update()
  pd.timer.updateTimers()
end
