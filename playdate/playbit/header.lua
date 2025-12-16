!if LOVE2D then
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

local windowWidth, windowHeight = playbit.graphics.getWindowSize()

love.graphics.setDefaultFilter("nearest", "nearest")
love.graphics.setLineWidth(1)
love.graphics.setLineStyle("rough")

math.randomseed(os.time())

local font = playdate.graphics.font.new("fonts/Phozon/Phozon")
playdate.graphics.setFont(font)

function love.draw()
  local rootContext = playbit.graphics.createRootContext()  

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

  love.graphics.setShader(playbit.graphics.shader)
  playbit.graphics.shader:send("white", playbit.graphics.colorWhite)
  playbit.graphics.shader:send("black", playbit.graphics.colorBlack)
  playbit.graphics.shader:send("transparent", playbit.graphics.colorTransparent)
  
  -- Clear the canvas every frame with black color (Playdate default)
  love.graphics.clear(playbit.graphics.COLOR_BLACK[1], playbit.graphics.COLOR_BLACK[2], playbit.graphics.COLOR_BLACK[3], playbit.graphics.COLOR_BLACK[4])
  
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
  love.graphics.setColor(1, 1, 1, 1)

  -- draw canvas to screen
  local currentCanvasScale = playbit.graphics.getCanvasScale()
  local x, y = playbit.graphics.getCanvasPosition()
  love.graphics.draw(rootContext.canvas, x, y, 0, currentCanvasScale, currentCanvasScale)

  -- reset back to set color
  playbit.graphics.applyColor(rootContext.color)

  -- update emulated input
  playdate.updateInput()
end

function love.textinput(text)
  playdate.keyboard._handleTextInput(text)
end

-- Hook into playbit's key callback system instead of overriding love.keypressed
playbit.keyPressed = function(key)
  -- Only handle keyboard input when keyboard is visible
  if playdate.keyboard.isVisible() then
    playdate.keyboard._handleKeyPressed(key)
  end
end

!end