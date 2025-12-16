--docs: https://sdk.play.date/2.6.2/Inside%20Playdate.html#C-graphics.image

local module = {}
playdate.graphics.image = module

local meta = {}
meta.__index = meta
module.__index = meta

function module.new(widthOrPath, height, bgcolor)
  local img = setmetatable({}, meta)

  if height then
    -- creating empty image with dimensions
    local imageData = love.image.newImageData(widthOrPath, height)
    
    -- Initialize with bgcolor (defaults to kColorClear = transparent)
    if bgcolor == playdate.graphics.kColorWhite then
      -- Fill with white
      imageData:mapPixel(function(x, y)
        return 1, 1, 1, 1
      end)
    elseif bgcolor == playdate.graphics.kColorBlack then
      -- Fill with black
      imageData:mapPixel(function(x, y)
        return 0, 0, 0, 1
      end)
    else
      bgcolor = playdate.graphics.kColorClear
    end
    -- kColorClear or nil defaults to transparent (already is)
    
    img.data = love.graphics.newImage(imageData)
    img._imageData = imageData -- Store imageData for sampling
    img._bgcolor = bgcolor -- Store bgcolor for canvas initialization
  else
    -- creating image from file
    img.data = love.graphics.newImage(widthOrPath..".png")
    -- Note: file-based images cannot be sampled without loading the imageData
  end

  return img
end

function meta:load(path)
  error("[ERR] playdate.graphics.image:load() is not yet implemented.")
end

function meta:copy()
  -- Create a new image that's a copy of this one
  local newImage = playdate.graphics.image.new(self:getWidth(), self:getHeight())
  playdate.graphics.pushContext(newImage)
  self:draw(0, 0)
  playdate.graphics.popContext()
  return newImage
end

function meta:getSize()
  return self.data:getWidth(), self.data:getHeight()
end

function meta:getWidth()
  return self.data:getWidth()
end

function meta:getHeight()
  return self.data:getHeight()
end

function module.imageSizeAtPath(path)
  error("[ERR] playdate.graphics.image.imageSizeAtPath() is not yet implemented.")
end

-- TODO: handle overloaded signatures:
-- (x, y, flip, sourceRect)
-- (p, flip, sourceRect)
function meta:draw(x, y, flip, qx, qy, qw, qh)
  -- always render pure white so its not tinted
  local r, g, b = love.graphics.getColor()
  love.graphics.setColor(1, 1, 1, 1)

  local sx = 1
  local sy = 1
  if flip then
    local w = self.data:getWidth()
    local h = self.data:getHeight()
    if flip == playdate.graphics.kImageFlippedX then
      sx = -1
      x = x + w
    elseif flip == playdate.graphics.kImageFlippedY then
      sy = -1
      y = y + h
    elseif flip == playdate.graphics.kImageFlippedXY then
      sx = -1
      sy = -1
      x = x + w
      y = y + h
    end
  end
  
  if qx and qy and qw and qh then
    local w, h = self:getSize()
    playbit.graphics.quad:setViewport(qx, qy, qw, qh, w, h)
    love.graphics.draw(self.data, playbit.graphics.quad, x, y, sx, sy)
  else
    love.graphics.draw(self.data, x, y, 0, sx, sy)
  end

  love.graphics.setColor(r, g, b, 1)
  playbit.graphics.updateContext()
end

function meta:drawAnchored(x, y, ax, ay, flip)
  error("[ERR] playdate.graphics.image:drawAnchored() is not yet implemented.")
end

function meta:drawCentered(x, y, flip)
  error("[ERR] playdate.graphics.image:drawCentered() is not yet implemented.")
end

function meta:clear(color)
  error("[ERR] playdate.graphics.image:clear() is not yet implemented.")
end

function meta:sample(x, y)
  -- For canvases, we need to read from the canvas data
  local imageData
  if self._canvas then
    -- If this is a canvas-backed image, get the ImageData from the canvas
    imageData = self._canvas:newImageData()
  elseif self._imageData then
    -- If this image was created with dimensions, we stored the imageData
    imageData = self._imageData
  else
    -- For file-based images without canvas, we can't sample
    -- Return kColorClear as a fallback
    return playdate.graphics.kColorClear
  end
  
  if not imageData then
    return playdate.graphics.kColorClear
  end
  
  -- Clamp coordinates to image bounds
  local width, height = self:getSize()
  if x < 0 or x >= width or y < 0 or y >= height then
    return playdate.graphics.kColorClear
  end
  
  -- Get the pixel color (RGBA)
  local r, g, b, a = imageData:getPixel(x, y)
  
  -- If transparent, return kColorClear
  if a < 0.5 then
    return playdate.graphics.kColorClear
  end
  
  -- Determine if it's white or black based on brightness
  local brightness = (r + g + b) / 3
  if brightness >= 0.5 then
    return playdate.graphics.kColorWhite
  else
    return playdate.graphics.kColorBlack
  end
end

function meta:drawRotated(x, y, angle, scale, yscale)
  @@ASSERT(scale == nil, "[ERR] Parameter scale is not yet implemented.")
  @@ASSERT(yscale == nil, "[ERR] Parameter yscale is not yet implemented.")

  -- always render pure white so its not tinted
  local r, g, b = love.graphics.getColor()
  love.graphics.setColor(1, 1, 1, 1)

  -- playdate.image.drawRotated() draws the texture centered, so emulate that
  love.graphics.push()
  local w = self.data:getWidth() * 0.5
  local h = self.data:getHeight() * 0.5

  -- using fractional numbers will cause jitter and artifacting
  w = math.floor(w)
  h = math.floor(h)

  love.graphics.translate(x, y)
  love.graphics.rotate(math.rad(angle))
  love.graphics.draw(self.data, -w, -h)
  love.graphics.pop()

  love.graphics.setColor(r, g, b, 1)
  playbit.graphics.updateContext()
end

function meta:rotatedImage(angle, scale, yscale)
  error("[ERR] playdate.graphics.image:rotatedImage() is not yet implemented.")
end

function meta:drawScaled(x, y, scale, yscale)
  yscale = yscale or scale

  -- always render pure white so its not tinted
  local r, g, b = love.graphics.getColor()
  love.graphics.setColor(1, 1, 1, 1)

  love.graphics.push()
  love.graphics.translate(x, y)
  love.graphics.scale(scale, yscale)
  love.graphics.draw(self.data, 0, 0)
  love.graphics.pop()

  love.graphics.setColor(r, g, b, 1)
  playbit.graphics.updateContext()
end

function meta:scaledImage(scale, yscale)
  error("[ERR] playdate.graphics.image:scaledImage() is not yet implemented.")
end


function meta:drawWithTransform(xform, x, y)
  error("[ERR] playdate.graphics.image:drawWithTransform() is not yet implemented.")
end

function meta:transformedImage(xform)
  error("[ERR] playdate.graphics.image:transformedImage() is not yet implemented.")
end

function meta:drawSampled(x, y, width, height, centerx, centery, dxx, dyx, dxy, dyy, dx, dy, z, tiltAngle, tile)
  error("[ERR] playdate.graphics.image:drawSampled() is not yet implemented.")
end

function meta:setMaskImage(maskImage)
  error("[ERR] playdate.graphics.image:setMaskImage() is not yet implemented.")
end

function meta:getMaskImage()
  error("[ERR] playdate.graphics.image:getMaskImage() is not yet implemented.")
end

function meta:addMask(opaque)
  error("[ERR] playdate.graphics.image:addMask() is not yet implemented.")
end

function meta:removeMask()
  error("[ERR] playdate.graphics.image:removeMask() is not yet implemented.")
end

function meta:hasMask()
  error("[ERR] playdate.graphics.image:hasMask() is not yet implemented.")
end

function meta:clearMask(opaque)
  error("[ERR] playdate.graphics.image:transformedImage() is not yet implemented.")
end

-- TODO: handle overloaded signature (rect, flip)
function meta:drawTiled(x, y, width, height, flip)
  error("[ERR] playdate.graphics.image:drawTiled() is not yet implemented.")
end

function meta:drawBlurred(x, y, radius, numPasses, ditherType, flip, xPhase, yPhase)
  error("[ERR] playdate.graphics.image:drawBlurred() is not yet implemented.")
end

function meta:blurredImage(radius, numPasses, ditherType, padEdges, xPhase, yPhase)
  error("[ERR] playdate.graphics.image:blurredImage() is not yet implemented.")
end

-- Bayer 8x8 dithering shader for drawFaded
local ditherShader = nil

local function getDitherShader()
  if not ditherShader then
    ditherShader = love.graphics.newShader[[
      uniform float alpha;
      
      // Bayer 8x8 matrix (values 0-63)
      const float bayer8x8[64] = float[64](
         0.0, 32.0,  8.0, 40.0,  2.0, 34.0, 10.0, 42.0,
        48.0, 16.0, 56.0, 24.0, 50.0, 18.0, 58.0, 26.0,
        12.0, 44.0,  4.0, 36.0, 14.0, 46.0,  6.0, 38.0,
        60.0, 28.0, 52.0, 20.0, 62.0, 30.0, 54.0, 22.0,
         3.0, 35.0, 11.0, 43.0,  1.0, 33.0,  9.0, 41.0,
        51.0, 19.0, 59.0, 27.0, 49.0, 17.0, 57.0, 25.0,
        15.0, 47.0,  7.0, 39.0, 13.0, 45.0,  5.0, 37.0,
        63.0, 31.0, 55.0, 23.0, 61.0, 29.0, 53.0, 21.0
      );
      
      vec4 effect(vec4 color, Image tex, vec2 tex_coords, vec2 screen_coords) {
        vec4 texcolor = Texel(tex, tex_coords);
        
        if (texcolor.a == 0.0) {
          return vec4(0.0, 0.0, 0.0, 0.0); // Transparent
        }
        
        // Get position in 8x8 Bayer matrix
        int x = int(mod(screen_coords.x, 8.0));
        int y = int(mod(screen_coords.y, 8.0));
        int index = y * 8 + x;
        
        // Get threshold from Bayer matrix
        float threshold = bayer8x8[index] / 63.0;
        
        // If alpha is less than threshold, discard this pixel (transparent)
        if (alpha < threshold) {
          discard;
        }
        
        // Otherwise, return the texture color as-is (already black or white)
        return texcolor;
      }
    ]]
  end
  return ditherShader
end

function meta:drawFaded(x, y, alpha, ditherType)
  -- Draw image with Bayer dithering to match Playdate behavior
  
  -- Save current state
  local currentShader = love.graphics.getShader()
  local r, g, b, a = love.graphics.getColor()
  
  -- Use dither shader
  local shader = getDitherShader()
  love.graphics.setShader(shader)
  shader:send("alpha", alpha)
  
  -- Draw with the dither shader
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(self.data, x, y, 0, 1, 1)
  
  -- Restore state
  love.graphics.setShader(currentShader)
  love.graphics.setColor(r, g, b, a)
  
  playbit.graphics.updateContext()
end

function meta:fadedImage(alpha, ditherType)
  -- Create a new image with faded effect
  local fadedImg = playdate.graphics.image.new(self:getWidth(), self:getHeight())
  playdate.graphics.pushContext(fadedImg)
  self:drawFaded(0, 0, alpha, ditherType)
  playdate.graphics.popContext()
  return fadedImg
end

function meta:setInverted(flag)
  error("[ERR] playdate.graphics.image:setInverted() is not yet implemented.")
end

function meta:invertedImage()
  error("[ERR] playdate.graphics.image:invertedImage() is not yet implemented.")
end

function meta:blendWithImage(image, alpha, ditherType)
  error("[ERR] playdate.graphics.image:blendWithImage() is not yet implemented.")
end

function meta:vcrPauseFilterImage()
  error("[ERR] playdate.graphics.image:vcrPauseFilterImage() is not yet implemented.")
end