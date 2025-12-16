-- Playdate display module for Love2D
local module = {}
playdate.display = module

local refreshRate = 30 -- Default Playdate refresh rate

function module.setRefreshRate(rate)
  refreshRate = rate
  -- Love2D doesn't directly control refresh rate, but we can track it
  -- The actual FPS limiting is handled by Love2D itself
end

function module.getRefreshRate()
  return refreshRate
end

function module.getWidth()
  return 400
end

function module.getHeight()
  return 240
end

function module.getSize()
  return 400, 240
end

function module.setFlipped(x, y)
  -- Not implemented for Love2D
  -- Playdate can flip display upside down
end

function module.setInverted(flag)
  -- Not implemented for Love2D
  -- This would invert all colors
end

function module.setScale(scale)
  -- Not implemented for Love2D
  -- Handled by playbit graphics layer
end

function module.setMosaic(x, y)
  -- Not implemented for Love2D
  -- Creates a mosaic/pixelation effect
end

function module.setOffset(x, y)
  playdate.graphics.setDrawOffset(x, y)
end

function module.getOffset()
  return playdate.graphics.getDrawOffset()
end

function module.loadImage(path)
  return playdate.graphics.image.new(path)
end

return module
