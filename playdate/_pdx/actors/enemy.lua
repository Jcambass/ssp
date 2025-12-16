import "consts"
import "actors/player"
import "animations/explosion"
import "weapons/stomp"
import "healthBar"


local pd <const> = playdate
local gfx <const> = playdate.graphics


class("Enemy").extends(gfx.sprite)

function Enemy:init(x, y, enemyData)
  Enemy.super.init(self)
  
  self:setImage(enemyData.image)
  self:setZIndex(Layers.Actors)
  self:moveTo(x, y)
  self:add()
  self.accumulatedSpeed = 0

  self:setCollideRect(0, 0, self:getSize())
  self:setGroups({CollisionGroups.Enemies})
  self:setCollidesWithGroups({CollisionGroups.Player, CollisionGroups.PlayerInView})

  self.health = enemyData.health
  self.speed = enemyData.speed
  self.earthDamage = enemyData.earthDamage
  self.playerDamage = enemyData.playerDamage
  self.scorePoints = enemyData.scorePoints
  self.healthBar = HealthBar(enemyData.health, self.x, self.y)

  local projectileSize = 3
  local projectileImage = gfx.image.new(projectileSize * 2, projectileSize * 2)
  gfx.pushContext(projectileImage)
    gfx.setColor(gfx.kColorBlack)
    gfx.fillCircleAtPoint(projectileSize, projectileSize, projectileSize)
  gfx.popContext()

  if enemyData.weaponClass then
    self.weapon = enemyData.weaponClass(self)
  end
end

function Enemy:hit(damage, pushback)
  self.health = self.health - damage
  self.healthBar:updateHealth(self.health)
  self:moveBy(0, -pushback)
  self.healthBar:moveBy(0, -pushback)

  if self.health <= 0 then
    self:remove()
    Explosion(self.x, self.y, 14)
    NOTIFICATION_CENTER:notify("increment_score", self.scorePoints)
  end
end

function Enemy:remove()
  Enemy.super.remove(self)

  self.healthBar:remove()
end

function Enemy:update()
  if self.halted then
    return
  end

  Enemy.super.update(self)

  self.accumulatedSpeed = self.accumulatedSpeed + self.speed
  if self.accumulatedSpeed >= 1 then
    local moveByY = math.floor(self.accumulatedSpeed)
    self.accumulatedSpeed =  math.fmod(self.accumulatedSpeed, moveByY)
    local actualX, actualY, collisions, length = self:moveWithCollisions(self.x, self.y + moveByY)
    self.healthBar:moveToInContext(actualX, actualY)

    if #collisions > 0 then
      for index, collision in ipairs(collisions) do
        local collidedObject = collision['other']
        if collidedObject:isa(Player) then
          self:remove()
          Explosion(actualX, actualY, 14)

          NOTIFICATION_CENTER:notify("decrement_player_health", self.playerDamage)
        end

        if self.weapon then
          if collidedObject:isa(PlayerInView) and actualY > 0 then
            self.weapon:shoot(self.x, self.y)
          end
        end
      end
    end

    if actualY > PLAYER_AREA_HEIGHT then
      self:remove()
      NOTIFICATION_CENTER:notify("decrement_earth_health", self.earthDamage)
    end
  end
end

function Enemy:collisionResponse()
  return "overlap"
end
