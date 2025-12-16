!if LOVE2D then
playbit = playbit or {}
local module = {}
playbit.graphics = module

-- #b0aea7
module.COLOR_WHITE = { 176 / 255, 174 / 255, 167 / 255, 1 }
-- #312f28
module.COLOR_BLACK = { 49 / 255, 47 / 255, 40 / 255, 1 }
module.COLOR_TRANSPARENT = { 0, 0, 0, 0 }

module.colorWhite = module.COLOR_WHITE
module.colorBlack = module.COLOR_BLACK
module.colorTransparent = module.COLOR_TRANSPARENT
module.shader = love.graphics.newShader("playdate/shader")
-- noop shader for now
-- module.shader = love.graphics.newShader([[
--   #pragma language glsl3

-- extern int mode;
-- extern bool debugDraw;
-- extern int pattern[64];
-- extern vec4 white;
-- extern vec4 black;
-- extern vec4 transparent;
-- // Dither parameters
-- extern bool ditherEnabled = false;
-- extern float ditherAlpha = 1.0;

--     vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
--     {

--       // Act like we're using all of these uniforms to avoid warnings
--       int m = mode;
--       bool dd = debugDraw;
--       int p[64];
--       for (int i = 0; i < 64; i++) {
--         p[i] = pattern[i];
--       }
--       vec4 w = white;
--       vec4 b = black;
--       vec4 t = transparent;


--       vec4 outputcolor = Texel(tex, texture_coords) * color;
--       return outputcolor;
--     }
-- ]])
module.drawOffset = { x = 0, y = 0}
module.activeFont = {}
module.contextStack = {}
-- shared quad to reduce gc
module.quad = love.graphics.newQuad(0, 0, 1, 1, 1, 1)
module.lastClearColor = module.colorWhite
module.drawPattern = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}

local canvasScale = 1
local canvasWidth = 400
local canvasHeight = 240
local canvasX = 0
local canvasY = 0
local windowWidth = 400
local windowHeight = 240
local fullscreen = false

function module.peakContext()
  if #module.contextStack == 0 then
    return nil
  else
    return module.contextStack[#module.contextStack]
  end
end

function module.createRootContext()
  -- must be changed at start of frame when canvas is not active
  -- render to canvas to allow 2x scaling
  local canvas = love.graphics.newCanvas()
  local newCanvasWidth, newCanvasHeight = module.getCanvasSize()
  local canvasWidth = canvas:getWidth()
  local canvasHeight = canvas:getHeight()
  if canvasWidth ~= newCanvasWidth or canvasHeight ~= newCanvasHeight then
    canvas = love.graphics.newCanvas(newCanvasWidth, newCanvasHeight)
  end

  -- push main canvas as root context
  local contextInfo = {
    canvas = canvas,
    drawMode = module.kDrawModeCopy,
    color = module.colorWhite,
    backgroundColor = module.colorBlack,
  }
  
  module.pushContext(contextInfo)

  return contextInfo
end

function module.pushContext(contextInfo)
  table.insert(module.contextStack, contextInfo)

  -- update render target
  love.graphics.setCanvas(contextInfo.canvas)

  -- update draw mode
  module.applyImageDrawMode(contextInfo.drawMode)

  -- set colors
  module.applyColor(contextInfo.color)
end

function module.popContext()
  -- Top level context cannot be popped
  if #module.contextStack <= 1 then
    return
  end

  -- pop context
  table.remove(module.contextStack)

  -- update current render target
  local activeContext = module.contextStack[#module.contextStack]
  love.graphics.setCanvas(activeContext.canvas)

  -- update draw mode
  module.applyImageDrawMode(activeContext.drawMode)

  -- set colors
  module.applyColor(activeContext.color)
end

module.kDrawModeCopy = 0
module.kDrawModeWhiteTransparent = 1
module.kDrawModeBlackTransparent = 2
module.kDrawModeFillWhite = 3
module.kDrawModeFillBlack = 4
module.kDrawModeXOR = 5
module.kDrawModeNXOR = 6
module.kDrawModeInverted = 7

function module.applyImageDrawMode(mode)
  if mode == module.kDrawModeCopy or mode == "copy" then
    playbit.graphics.shader:send("mode", 0)
  elseif mode == module.kDrawModeWhiteTransparent or mode == "whiteTransparent" then
    playbit.graphics.shader:send("mode", 1)
  elseif mode == module.kDrawModeBlackTransparent or mode == "blackTransparent" then
    playbit.graphics.shader:send("mode", 2)
  elseif mode == module.kDrawModeFillWhite or mode == "fillWhite" then
    playbit.graphics.shader:send("mode", 3)
  elseif mode == module.kDrawModeFillBlack or mode == "fillBlack" then
    playbit.graphics.shader:send("mode", 4)
  elseif mode == module.kDrawModeXOR or mode == "XOR" then
    playbit.graphics.shader:send("mode", 5)
  elseif mode == module.kDrawModeNXOR or mode == "NXOR" then
    playbit.graphics.shader:send("mode", 6)
  elseif mode == module.kDrawModeInverted or mode == "inverted" then
    playbit.graphics.shader:send("mode", 7)
  else
    error("[ERR] Draw mode '"..mode.."' is not yet implemented.")
  end
end

function module.applyColor(c)
  love.graphics.setColor(c[1], c[2], c[3], c[4])
end

--- Sets the scale of the canvas.
---@param scale number
function module.setCanvasScale(scale)
  canvasScale = scale
end

---Returns the current scale of the canvas.
---@return number
function module.getCanvasScale()
  return canvasScale
end

--- Sets the canvas size.
---@param width number
---@param height number
function module.setCanvasSize(width, height)
  canvasWidth = width
  canvasHeight = height
end

--- Returns the current canvas size.
---@return integer width
---@return integer height
function module.getCanvasSize()
  return canvasWidth, canvasHeight
end

--- Sets the canvas position within the window.
---@param x any
---@param y any
function module.setCanvasPosition(x, y)
  canvasX = x
  canvasY = y
end

--- Returns the current canvas position within the window.
---@return integer x
---@return integer y
function module.getCanvasPosition()
  return canvasX, canvasY
end

--- Sets the size of the window.
---@param width number
---@param height number
function module.setWindowSize(width, height)
  windowWidth = width
  windowHeight = height
end

--- Returns the current window size.
---@return integer width
---@return integer height
function module.getWindowSize()
  return windowWidth, windowHeight
end

--- Sets fullscreen (true) or window mode (false).
---@param enabled any
function module.setFullscreen(enabled)
  fullscreen = enabled
end

--- Returns if the game is in fullscreen (true) or window mode (false).
---@return boolean
function module.getFullscreen()
  return fullscreen
end

--- Sets the colors used when drawing graphics.
---@param white table An array of 4 values that correspond to RGBA that range from 0 to 1.
---@param black table An array of 4 values that correspond to RGBA that range from 0 to 1.
function module.setColors(white, black)
  if white == nil then
    white = module.COLOR_WHITE
  end
  if black == nil then
    black = module.COLOR_BLACK
  end
  
  module.colorWhite = white
  module.colorBlack = black
  module.shader:send("white", white)
  module.shader:send("black", black)
end

function module.updateContext()
  if #module.contextStack == 0 then
    return
  end

  local activeContext = module.contextStack[#module.contextStack]

  module.applyImageDrawMode(activeContext.drawMode)
  module.applyColor(activeContext.color)

  if not activeContext.image then
    return
  end

  -- love2d doesn't allow calling newImageData() when canvas is active
  love.graphics.setCanvas()
  local imageData = activeContext.canvas:newImageData()
  love.graphics.setCanvas(activeContext.canvas)


  -- update image
  activeContext.image.data:replacePixels(imageData)
end
!end