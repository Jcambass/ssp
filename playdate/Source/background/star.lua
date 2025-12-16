import "consts"

!if PLAYDATE then
local pd <const> = playdate
local gfx <const> = playdate.graphics
!else
local pd = playdate
local gfx = playdate.graphics
!end

class("Star").extends(gfx.sprite)

function Star:init(x, y, speed, image)
  self:moveTo(x, y)
  self:setImage(image)
  self:setZIndex(Layers.Stars)
  self:add()

  self.accumulatedSpeed = 0
  self.speed = speed

  local starX, starY = self:getSize()
  self.radius = starY / 2
end

function Star:update()
  if self.halted then
    return
  end

  Star.super.update(self)

  self.accumulatedSpeed = self.accumulatedSpeed + self.speed
  if self.accumulatedSpeed >= 1 then
    local moveByY = math.floor(self.accumulatedSpeed)
    self.accumulatedSpeed =  math.fmod(self.accumulatedSpeed, moveByY)
    self:moveBy(0, moveByY)
  end

  local x, y = self:getPosition()

  local topPoint = y - self.radius
  if topPoint > PLAYER_AREA_HEIGHT then
    self:remove()
  end
end
