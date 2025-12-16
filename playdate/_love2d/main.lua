-- Name this file `main.lua`. Your game can use multiple source files if you wish
-- (use the `import "myFilename"` command), but the simplest games can be written
-- with just `main.lua`.

-- You'll want to import these in just about every project you'll work on.


require("playbit.graphics")

--[[ since there is no CoreLibs/playdate, this file should always 
be included here so the methods are always available ]]--
require("playdate.playdate")
--[[ not really a way around including this one, but probably doesn't really
matter as all games are going to need to import graphics to draw stuff ]]--
require("playdate.graphics")

function import(path)
  if string.match(path, "^CoreLibs/") then
    path = string.gsub(path, "/", ".")
    path = string.gsub(path, "CoreLibs", "playdate")
    return require(path)
  end
  path = string.gsub(path, "/", ".")
  return require(path)
end

local firstFrame = true
local windowWidth, windowHeight = playbit.graphics.getWindowSize()

playbit.graphics.canvas:setFilter("nearest", "nearest")

love.graphics.setDefaultFilter("nearest", "nearest")
love.graphics.setLineWidth(1)
love.graphics.setLineStyle("rough")

playdate.graphics.setBackgroundColor(playdate.graphics.kColorWhite)
playdate.graphics.setColor(playdate.graphics.kColorBlack)

math.randomseed(os.time())

local font = playdate.graphics.font.new("fonts/Phozon/Phozon")
playdate.graphics.setFont(font)

function love.draw()
  -- must be changed at start of frame when canvas is not active
  local newCanvasWidth, newCanvasHeight = playbit.graphics.getCanvasSize()
  local canvasWidth = playbit.graphics.canvas:getWidth()
  local canvasHeight = playbit.graphics.canvas:getHeight()
  if canvasWidth ~= newCanvasWidth or canvasHeight ~= newCanvasHeight then
    playbit.graphics.canvas = love.graphics.newCanvas(newCanvasWidth, newCanvasHeight)
  end

  -- must be changed at start of frame - love2d doesn't allow changing window size with canvas active
  local newWindowWidth, newWindowHeight = playbit.graphics.getWindowSize()
  local fullscreen = playbit.graphics.getFullscreen()
  local w, y, flags = love.window.getMode()
  if windowWidth ~= newWindowWidth or windowHeight ~= newWindowHeight or flags.fullscreen ~= fullscreen then
    flags.fullscreen = fullscreen

    -- stop window from ending up off screen when switching back from fullscreen
    if flags.x < 50 then
      flags.x = 50
    end
    if flags.y < 50 then
      flags.y = 50
    end

    love.window.setMode(newWindowWidth, newWindowHeight, flags)
    windowWidth = newWindowWidth
    windowHeight = newWindowHeight
  end

  -- render to canvas to allow 2x scaling
  love.graphics.setCanvas(playbit.graphics.canvas)
  love.graphics.setShader(playbit.graphics.shader)

  --[[ 
    Love2d won't allow a canvas to be set outside of the draw function, so we need to do this on the first frame of draw.
    Otherwise setting the bg color outside of playdate.update() won't be consistent with PD.
  --]]
  if firstFrame then
    local c = playbit.graphics.lastClearColor
    love.graphics.clear(c.r, c.g, c.b, 1)
    firstFrame = false
  end

  -- love requires that this is set every loop
  love.graphics.setFont(playbit.graphics.activeFont.data)

  -- push main transform for draw offset
  love.graphics.push()
  love.graphics.translate(playbit.graphics.drawOffset.x, playbit.graphics.drawOffset.y)

  -- main update
  playdate.update()

  -- debug draw
  if playdate.debugDraw then
    playbit.graphics.shader:send("debugDraw", true)
    playdate.debugDraw()
    playbit.graphics.shader:send("debugDraw", false)
  end

  -- pop main transform for draw offset
  love.graphics.pop()

  -- pop canvas
  love.graphics.setCanvas()

  -- clear shader so that canvas is rendered normally
  love.graphics.setShader()

  -- always render pure white so its not tinted
  local r, g, b = love.graphics.getColor()
  love.graphics.setColor(1, 1, 1, 1)

  -- draw canvas to screen
  local currentCanvasScale = playbit.graphics.getCanvasScale()
  local x, y = playbit.graphics.getCanvasPosition()
  love.graphics.draw(playbit.graphics.canvas, x, y, 0, currentCanvasScale, currentCanvasScale)

  -- reset back to set color
  love.graphics.setColor(r, g, b, 1)

  -- update emulated input
  playdate.updateInput()
end



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
