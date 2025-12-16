import "consts"
import "weapons/weapon"

!if PLAYDATE then
local pd <const> = playdate
local gfx <const> = playdate.graphics
!else
local pd = playdate
local gfx = playdate.graphics
!end

class("Ratata").extends(Weapon)

function Ratata:init(actor)
  local projectileImage = gfx.image.new(2, 15)
  gfx.pushContext(projectileImage)
    gfx.setColor(gfx.kColorWhite)
    gfx.fillRoundRect(0, 0, 2, 15, 4)
  gfx.popContext()

  if actor:isa(Enemy) then
    Ratata.super.init(self, "Ratata 9000", projectileImage, 100, {{-6, 0}, {6, 0}}, {0, 0}, 10, 3, 0, false)
  else
    local playerSpriteSizeX, playerSpriteSizeY = actor:getSize()
    local wingTip = playerSpriteSizeX / 2
    mountingPoint = {-wingTip, 0}

    Ratata.super.init(self, "Ratata 9000", projectileImage, 100, {{-wingTip, 0}, {-wingTip + 5, 0}, {wingTip-5, 0}, {wingTip, 0}}, {0, -wingTip}, 15, 3, 0, true)
  end
end
