import "consts"
import "weapons/weapon"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class("Stomp").extends(Weapon)

function Stomp:init(actor)
  local projectileImage = gfx.image.new(4, 10)
  gfx.pushContext(projectileImage)
    gfx.setColor(gfx.kColorWhite)
    gfx.fillRoundRect(0, 0, 4, 10, 4)
  gfx.popContext()

  if actor:isa(Enemy) then
    Stomp.super.init(self, "Stomp O Matic", projectileImage, 300, {{0, 0}}, {0, 0}, 2, 6, 0, false)
  else
    local playerSpriteSizeX, playerSpriteSizeY = actor:getSize()
    local leftWingTip = playerSpriteSizeX / 2
    mountingPoint = {-leftWingTip, 0}

    Stomp.super.init(self, "Stomp O Matic", projectileImage, 300, {{0, 0}}, mountingPoint, 5, 10, 0, true)
  end
end
