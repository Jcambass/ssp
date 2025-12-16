import "consts"


local pd <const> = playdate
local gfx <const> = playdate.graphics


class("Planet").extends(gfx.sprite)

function Planet:init(x, y, speed, planetImage)
  Planet.super.init(self)
  
  self:moveTo(x, y)
  self:setImage(planetImage)
  self:setZIndex(Layers.Planets)
  self:add()

  local planetX, planetY = self:getSize()
  self.planetX = planetX
  self.planetY = planetY

  self.accumulatedSpeed = 0
  self.speed = speed
end

function Planet:update()
  if self.halted then
    return
  end

  Planet.super.update(self)

  self.accumulatedSpeed = self.accumulatedSpeed + self.speed
  if self.accumulatedSpeed >= 1 then
    local moveByY = math.floor(self.accumulatedSpeed)
    self.accumulatedSpeed =  math.fmod(self.accumulatedSpeed, moveByY)
    self:moveBy(0, moveByY)
  end

  local x, y = self:getPosition()

  local topPoint = y - self.planetY/2
  if topPoint > PLAYER_AREA_HEIGHT then
    self:remove()
  end
end
