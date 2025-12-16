import "consts"
import "actors/player"
import "CoreLibs/animation"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local explosionImageTable = gfx.imagetable.new("Images/animations/smoke")

class("Explosion").extends(gfx.sprite)

function Explosion:init(x, y, nr)
  -- Setting the last argument to false makes the animation stop on the last frame
  local frameTime = 50
  local animationLoop = gfx.animation.loop.new(frameTime, explosionImageTable, false)
  animationLoop.startFrame = (nr -1) * 12 + 1
  animationLoop.endFrame = 12 * nr

  self.animationLoop = animationLoop

  self:setImage(self.animationLoop:image())
  self:setZIndex(Layers.Actors)
  self:moveTo(x, y)
  self:add()
end

function Explosion:update()
  self:setImage(self.animationLoop:image())
  if not self.animationLoop:isValid() then
      self:remove()
  end
end
