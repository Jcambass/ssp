import "consts"
import "weapons/stomp"
import "weapons/blaster"
import "weapons/grim"
import "weapons/hammer"
import "weapons/ratata"
import "CoreLibs/crank"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class("PlayerInView").extends(gfx.sprite)

function PlayerInView:init(playerSpriteSizeX)
  self:setSize(playerSpriteSizeX - 12, PLAYER_AREA_HEIGHT * 2)
  self:setCollideRect(0, 0, self:getSize())
  self:setZIndex(Layers.Actors)
  self:setGroups({CollisionGroups.PlayerInView})

  self:add()
end

class("Player").extends(gfx.sprite)

function Player:init(x, y)
  local playerImage = gfx.image.new("Images/player")
  assert( playerImage ) -- make sure the image was where we thought

  self:moveTo(x, y)
  self:setImage(playerImage)

  self:setCollideRect(0, 0, self:getSize())
  self:setGroups({CollisionGroups.Player})

  self:setZIndex(Layers.Actors)
  self:add()

  local playerSpriteSizeX, playerSpriteSizeY = self:getSize()
  self.xOffset = playerSpriteSizeX / 2
  self.yOffset = playerSpriteSizeY / 2

  self.enemyTarget = PlayerInView(playerSpriteSizeX)

  self.speed = 4
  self.level = 1
  self.level_scores = {500, 2000, 3000, 4000, 5500}

  local projectileSize = 3
  local projectileImage = gfx.image.new(projectileSize * 2, projectileSize * 2)
  gfx.pushContext(projectileImage)
    gfx.setColor(gfx.kColorWhite)
    gfx.drawCircleAtPoint(projectileSize, projectileSize, projectileSize)
  gfx.popContext()

  self.weapons = {}
  self.weapons[1] = Stomp(self)
  self.weapons[2] = Blaster(self)
  self.weapons[3] = Hammer(self)
  self.weapons[4] = Ratata(self)
  self.weapons[5] = Grim(self)
  self.currentWeapon = 1

  self.weapon = Stomp(self)

  NOTIFICATION_CENTER:subscribe("score_updated", function(score)
    if score > self.level_scores[self.level] then
      if self.level < 5 then
        self.level = self.level + 1
        local unlockedWeapon = self.weapons[self.level]
        NOTIFICATION_CENTER:notify("display_message", "LEVEL UP! New weapon " .. unlockedWeapon.name .. " unlocked.", 3000)
      end
    end
 end)
end

function Player:update()
  if self.halted then
    return
  end

  Player.super.update(self)

  if playdate.buttonIsPressed( playdate.kButtonUp ) then
      if self.y - self.yOffset - self.speed >= 0 then
          self:moveBy( 0, -self.speed )
      end
  end
  if playdate.buttonIsPressed( playdate.kButtonRight ) then
      if self.x + self.xOffset + self.speed <= PLAYER_AREA_WIDTH then
          self:moveBy( self.speed, 0 )
      end
  end
  if playdate.buttonIsPressed( playdate.kButtonDown ) then
      if self.y + self.yOffset + self.speed <= PLAYER_AREA_HEIGHT then
        self:moveBy( 0, self.speed )
      end
  end
  if playdate.buttonIsPressed( playdate.kButtonLeft ) then
      if self.x - self.xOffset- self.speed >= 0 then
        self:moveBy( -self.speed, 0 )
      end
  end

  local change, acceleratedChange = pd.getCrankChange()

  if math.abs(change) > 0 then
    local crankTicks = pd.getCrankTicks(1)

    NOTIFICATION_CENTER:notify("increment_player_health", crankTicks)
  else
    if playdate.buttonJustPressed( pd.kButtonA ) then
      self.weapon:shoot(self.x, self.y)
    end

    if playdate.buttonJustPressed( pd.kButtonB ) then
      self:cycleWeapon()
    end
  end

  self.enemyTarget:moveTo(self.x, self.y)
end

function Player:cycleWeapon ()
  local oldWeapon = self.currentWeapon
  local maxUnlockedWeapon = self.level

  self.currentWeapon = self.currentWeapon + 1
  if self.currentWeapon > maxUnlockedWeapon then
    self.currentWeapon = 1
  end

  if self.currentWeapon == oldWeapon then
    return
  end

  self.weapon = self.weapons[self.currentWeapon]
  NOTIFICATION_CENTER:notify("display_message", "Weapon switched to " .. self.weapon.name, 2000)
end