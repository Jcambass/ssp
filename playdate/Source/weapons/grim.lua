import "consts"
import "weapons/weapon"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class("Grim").extends(Weapon)

function Grim:init(actor)
  local projectileImage = gfx.image.new(12, 12)

  if actor:isa(Enemy) then
    gfx.pushContext(projectileImage)
      gfx.setColor(gfx.kColorWhite)
      gfx.drawCircleAtPoint(6, 8, 3)
      gfx.drawCircleAtPoint(3, 3, 3)
      gfx.drawCircleAtPoint(9, 3, 3)
    gfx.popContext()
    Grim.super.init(self, "Grim Reaper", projectileImage, 2000, {{0, 0}}, {0, 0}, 2, 15, 0, false)
  else
    gfx.pushContext(projectileImage)
      gfx.setColor(gfx.kColorWhite)
      gfx.drawCircleAtPoint(6, 3, 3)
      gfx.drawCircleAtPoint(3, 8, 3)
      gfx.drawCircleAtPoint(9, 8, 3)
    gfx.popContext()
    Grim.super.init(self, "Grim Reaper", projectileImage, 700, {{0, 0}}, {0, 0}, 5, 50, 0, true)
  end
end
