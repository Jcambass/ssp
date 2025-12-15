import "consts"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class("HealthBar").extends(gfx.sprite)

function HealthBar:init(fullHealth, x, y)
  self.fullHealth = fullHealth

  self.height = 4
  self.width = 20
  self.radius = 5

  self.enemyOffset = 20

  self:setSize(self.width, self.height)
  self:setZIndex(Layers.Actors)
  self:moveToInContext(x, y)

  local image = gfx.image.new(self.width, self.height)
  gfx.pushContext(image)
    gfx.setColor(gfx.kColorWhite)
    gfx.drawRoundRect(0, 0, self.width, self.height, self.radius)
    gfx.fillRoundRect(0, 0, self.width, self.height, self.radius)
  gfx.popContext()
  self:setImage(image)

  self:add()
end

function HealthBar:updateHealth(health)
  local healthPercentage = health / self.fullHealth
  local healthBarWidth = self.width * healthPercentage
  -- TODO: Optimise this with a mask maybe?
  local image = gfx.image.new(self.width, self.height)
  gfx.pushContext(image)
    gfx.setColor(gfx.kColorWhite)
    gfx.drawRoundRect(0, 0, self.width, self.height, self.radius)
    -- Draw at 1 and subtract 1 from the width to avoid the short inner bar having a square edge showing.
    gfx.fillRoundRect(1, 0, healthBarWidth - 1, self.height, self.radius)
  gfx.popContext()
  self:setImage(image)
end

function HealthBar:moveToInContext(x, y)
  self:moveTo(x, y - self.enemyOffset)
end