import "consts"
import "weapons/weapon"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class("Blaster").extends(Weapon)

function Blaster:init(actor)
  local projectileSize = 3
  local projectileImage = gfx.image.new(projectileSize * 2, projectileSize * 2)
  gfx.pushContext(projectileImage)
    gfx.setColor(gfx.kColorWhite)
    gfx.drawCircleAtPoint(projectileSize, projectileSize, projectileSize)
  gfx.popContext()

  if actor:isa(Enemy) then
    Blaster.super.init(self, "Space Blaster", projectileImage, 300, {{0, 0}}, {0, 0}, 8, 20, 0, false)
  else
    local playerSpriteSizeX, playerSpriteSizeY = actor:getSize()
    local wingTip = playerSpriteSizeX / 2
    mountingPoint = {wingTip, 0}

    Blaster.super.init(self, "Space Blaster", projectileImage, 300, {{0, 0}}, mountingPoint, 8, 20, 0, true)
  end
end
