import "consts"
import "weapons/weapon"

!if PLAYDATE then
local pd <const> = playdate
local gfx <const> = playdate.graphics
!else
local pd = playdate
local gfx = playdate.graphics
!end

class("Hammer").extends(Weapon)

function Hammer:init(actor)
  local projectileImage = gfx.image.new(4, 6)
  gfx.pushContext(projectileImage)
    gfx.setColor(gfx.kColorWhite)
    gfx.fillRoundRect(0, 0, 4, 6, 4)
  gfx.popContext()

  local gunPositions = {{-10, 0}, {0, 0}, {10, 0}}
  if actor:isa(Enemy) then
    Hammer.super.init(self, "Space Hammer", projectileImage, 2000, gunPositions, {0, 0}, 2, 4, 10, false)
  else
    Hammer.super.init(self, "Space Hammer", projectileImage, 200, gunPositions, {0, 6}, 5, 10, 10, true)
  end
end
