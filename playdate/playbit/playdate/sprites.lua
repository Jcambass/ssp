-- Playdate sprite implementation for Love2D
require("playdate.object")

local module = {}
playdate.graphics.sprite = module

-- Sprite list management
local allSprites = {}
local spriteCount = 0
local backgroundDrawingCallback = nil

-- Sort sprites by z-index
local function sortSprites()
  table.sort(allSprites, function(a, b)
    return (a.zIndex or 0) < (b.zIndex or 0)
  end)
end

-- Sprite class
local Sprite = {}
Sprite.__index = Sprite
Sprite.className = "Sprite"
Sprite.class = Sprite
Sprite.super = Object

-- Copy Object methods to Sprite so they're available to subclasses
Sprite.isa = Object.isa

-- Set up inheritance from Object via metatable
setmetatable(Sprite, { __index = Object })

-- Inherit baseObject from Object
function Sprite.baseObject()
  return Object.baseObject()
end

function Sprite:init()
  self.x = 0
  self.y = 0
  self.width = 0
  self.height = 0
  self.image = nil
  self.zIndex = 0
  self.visible = true
  self.added = false
  self.centerX = 0.5
  self.centerY = 0.5
  self.rotation = 0
  self.scale = 1
  self.alpha = 1
  self.collideRect = nil
  self.tag = 0
  self.ignoresDrawOffset = false
end

function Sprite:add()
  if not self.added then
    table.insert(allSprites, self)
    spriteCount = spriteCount + 1
    self.added = true
    sortSprites()
  end
end

function Sprite:remove()
  if self.added then
    for i, sprite in ipairs(allSprites) do
      if sprite == self then
        table.remove(allSprites, i)
        spriteCount = spriteCount - 1
        self.added = false
        break
      end
    end
  end
end

function Sprite:moveTo(x, y)
  self.x = x
  self.y = y
end

function Sprite:moveWithCollisions(x, y)
  -- Simple movement with collision detection
  -- Returns: actualX, actualY, collisions, length
  local oldX, oldY = self.x, self.y
  self.x = x
  self.y = y
  
  -- Check for collisions with other sprites
  local collisions = {}
  local rect = self.collideRect
  if rect then
    -- Get the sprite's bounds (accounts for center point)
    local boundsX, boundsY, boundsW, boundsH = self:getBounds()
    -- Collision rect is relative to the sprite's bounds
    local x1 = boundsX + rect.x
    local y1 = boundsY + rect.y
    local x2 = x1 + rect.width
    local y2 = y1 + rect.height
    
    for _, other in ipairs(allSprites) do
      if other ~= self and other.collideRect then
        -- Check if collision should happen based on collision groups
        local shouldCollide = false
        if self.collidesWithGroups and other.groups then
          for _, myCollideGroup in ipairs(self.collidesWithGroups) do
            for _, otherGroup in ipairs(other.groups) do
              if myCollideGroup == otherGroup then
                shouldCollide = true
                break
              end
            end
            if shouldCollide then break end
          end
        end
        
        if shouldCollide then
          local oRect = other.collideRect
          -- Get other sprite's bounds
          local oBoundsX, oBoundsY, oBoundsW, oBoundsH = other:getBounds()
          local ox1 = oBoundsX + oRect.x
          local oy1 = oBoundsY + oRect.y
          local ox2 = ox1 + oRect.width
          local oy2 = oy1 + oRect.height
          
          -- Check for AABB collision
          if x1 < ox2 and x2 > ox1 and y1 < oy2 and y2 > oy1 then
            -- Playdate returns collision info with 'other' field and collision details
            table.insert(collisions, {
              other = other,
              type = nil, -- Could be "slide", "freeze", "overlap", "bounce"
              bounce = false,
              slide = false,
              overlaps = true
            })
          end
        end
      end
    end
  end
  
  local length = math.sqrt((x - oldX)^2 + (y - oldY)^2)
  return x, y, collisions, length
end

function Sprite:moveBy(dx, dy)
  self.x = self.x + dx
  self.y = self.y + dy
end

function Sprite:setImage(image, flip, scale)
  self.image = image
  if image then
    self.width = image:getWidth()
    self.height = image:getHeight()
  end
  self.flip = flip or playdate.graphics.kImageUnflipped
  if scale then
    self.scale = scale
  end
end

function Sprite:getImage()
  return self.image
end

function Sprite:setSize(width, height)
  self.width = width
  self.height = height
end

function Sprite:getSize()
  return self.width, self.height
end

function Sprite:setCenter(x, y)
  self.centerX = x
  self.centerY = y
end

function Sprite:getCenter()
  return self.centerX, self.centerY
end

function Sprite:setZIndex(zIndex)
  self.zIndex = zIndex
  if self.added then
    sortSprites()
  end
end

function Sprite:getZIndex()
  return self.zIndex
end

function Sprite:setVisible(visible)
  self.visible = visible
end

function Sprite:isVisible()
  return self.visible
end

function Sprite:setRotation(rotation)
  self.rotation = rotation
end

function Sprite:getRotation()
  return self.rotation
end

function Sprite:setScale(scale)
  self.scale = scale
end

function Sprite:getScale()
  return self.scale
end

function Sprite:setTag(tag)
  self.tag = tag
end

function Sprite:getTag()
  return self.tag
end

function Sprite:setIgnoresDrawOffset(ignore)
  self.ignoresDrawOffset = ignore
end

function Sprite:getIgnoresDrawOffset()
  return self.ignoresDrawOffset or false
end

function Sprite:markDirty()
  -- In Love2D we redraw every frame, so this is a no-op
  -- In Playdate this tells the display system the sprite needs redrawing
end

function Sprite:setGroups(groups)
  self.groups = groups
end

function Sprite:getGroups()
  return self.groups or {}
end

function Sprite:setCollidesWithGroups(groups)
  self.collidesWithGroups = groups
end

function Sprite:getCollidesWithGroups()
  return self.collidesWithGroups or {}
end

function Sprite:getBounds()
  local width = self.width
  local height = self.height
  local x = self.x - width * self.centerX
  local y = self.y - height * self.centerY
  return x, y, width, height
end

function Sprite:getBoundsRect()
  local x, y, width, height = self:getBounds()
  return playdate.geometry.rect.new(x, y, width, height)
end

function Sprite:setCollideRect(x, y, width, height)
  self.collideRect = {x = x, y = y, width = width, height = height}
end

function Sprite:getCollideRect()
  if self.collideRect then
    local spriteX, spriteY = self:getBounds()
    return spriteX + self.collideRect.x, spriteY + self.collideRect.y,
           self.collideRect.width, self.collideRect.height
  end
  return self:getBounds()
end

function Sprite:clearCollideRect()
  self.collideRect = nil
end

function Sprite:getPosition()
  return self.x, self.y
end

function Sprite:draw()
  if not self.visible then return end
  
  if self.image then
    local drawX = self.x - self.width * self.centerX
    local drawY = self.y - self.height * self.centerY
    
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    
    if self.rotation ~= 0 then
      love.graphics.rotate(math.rad(self.rotation))
    end
    
    if self.scale ~= 1 then
      love.graphics.scale(self.scale, self.scale)
    end
    
    love.graphics.translate(-self.x, -self.y)
    
    self.image:draw(drawX, drawY)
    
    love.graphics.pop()
  end
end

function Sprite:update()
  -- Override this in subclasses
end

function Sprite:collisionResponse(other)
  -- Override this in subclasses
  -- Should return collision response type
  return nil
end

-- Module functions
function module.new(image)
  local sprite = setmetatable({}, Sprite)
  sprite:init()
  if image then
    sprite:setImage(image)
  end
  return sprite
end

-- Internal function to update and draw all sprites
local function updateAndDrawAllSprites()
  -- Call background drawing callback if set
  if backgroundDrawingCallback then
    backgroundDrawingCallback(0, 0, 400, 240)
  end
  
  -- Update all sprites
  for _, sprite in ipairs(allSprites) do
    if sprite.update and type(sprite.update) == "function" then
      sprite:update()
    end
  end
  
  -- Draw all sprites
  local drawnCount = 0
  local invisibleCount = 0
  local noImageCount = 0
  for _, sprite in ipairs(allSprites) do
    if not sprite.visible then
      invisibleCount = invisibleCount + 1
    elseif not sprite.image then
      noImageCount = noImageCount + 1
    else
      drawnCount = drawnCount + 1
    end
    sprite:draw()
  end
  
  -- Occasionally print draw count
  if math.random() < 0.01 then
    print("Sprites: " .. #allSprites .. " total, " .. drawnCount .. " drawn, " .. invisibleCount .. " invisible, " .. noImageCount .. " no image")
  end
end

function module.removeAll()
  allSprites = {}
  spriteCount = 0
end

function module.getAllSprites()
  return allSprites
end

function module.spriteCount()
  return spriteCount
end

function module.setBackgroundDrawingCallback(callback)
  backgroundDrawingCallback = callback
end

function module.addSprite(sprite)
  sprite:add()
end

function module.removeSprite(sprite)
  sprite:remove()
end

function module.addEmptyCollisionSprite(x, y, width, height)
  local sprite = module.new()
  sprite:setSize(width, height)
  sprite:moveTo(x, y)
  sprite:add()
  return sprite
end

function module.setAlwaysRedraw(flag)
  -- Not implemented for Love2D
end

function module.addDirtyRect(x, y, width, height)
  -- Not implemented for Love2D
end

function module.setClipRectsInRange(x, y, width, height, startZ, endZ)
  -- Not implemented for Love2D
end

function module.clearClipRectsInRange(startZ, endZ)
  -- Not implemented for Love2D
end

function module.setStencilImage(image, tile)
  -- Not implemented for Love2D
end

function module.clearStencil()
  -- Not implemented for Love2D
end

function module.setStencilPattern(pattern, x, y)
  -- Not implemented for Love2D
end

function module.clearStencilPattern()
  -- Not implemented for Love2D
end

-- Set up sprite as part of graphics module
playdate.graphics.sprite = setmetatable(module, {
  __index = Sprite,
  __call = function(self, image)
    return module.new(image)
  end
})

-- Copy Sprite class properties to module so extends() works
module.baseObject = Sprite.baseObject
module.init = Sprite.init
module.className = Sprite.className
module.class = Sprite.class
module.super = Sprite.super

-- Add the update function with a special name to avoid conflicts
-- Don't name it 'update' to prevent it from shadowing Sprite:update()
module.updateSprites = updateAndDrawAllSprites

return module
