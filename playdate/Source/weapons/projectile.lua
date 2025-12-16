import "consts"
import "animations/explosion"

!if PLAYDATE then
local pd <const> = playdate
local gfx <const> = playdate.graphics
!else
local pd = playdate
local gfx = playdate.graphics
!end

class("Projectile").extends(gfx.sprite)

function Projectile:init(projectileImage, x, y, speed, damage, pushback, playerOriginated)
  Projectile.super.init(self)
  
  self.playerOriginated = playerOriginated

  local projectileImageX, projectileImageY = projectileImage:getSize()
  self.projectileSize = projectileImageX / 2

  self:setImage(projectileImage)

  self.speed = speed
  self.damage = damage
  self.pushback = pushback

  self:setCollideRect(0, 0, self:getSize())
  if playerOriginated then
    self:setGroups({CollisionGroups.PlayerProjectiles})
    self:setCollidesWithGroups({CollisionGroups.Enemies})
  else
    self:setGroups({CollisionGroups.EnemyProjectiles})
    self:setCollidesWithGroups({CollisionGroups.Player})
  end

  self:setZIndex(Layers.Projectiles)
  self:moveTo(x, y)
  self:add()
end

function Projectile:update()
  if self.halted then
    return
  end

  Projectile.super.update(self)

  if self.playerOriginated then
    self:updatePlayerProjectile()
  else
    self:updateEnemyProjectile()
  end
end

function Projectile:updatePlayerProjectile()
  local actualX, actualY, collisions, length = self:moveWithCollisions(self.x, self.y - self.speed)
  if #collisions > 0 then
    for index, collision in ipairs(collisions) do
      local collidedObject = collision['other']
      if collidedObject:isa(Enemy) then
        collidedObject:hit(self.damage, self.pushback)
      end
    end
    self:remove()
  elseif actualY < 0 - self.projectileSize then
    self:remove()
  end
end

function Projectile:updateEnemyProjectile()
  local actualX, actualY, collisions, length = self:moveWithCollisions(self.x, self.y + self.speed)
  if #collisions > 0 then
    for index, collision in ipairs(collisions) do
      local collidedObject = collision['other']
      if collidedObject:isa(Player) then
        NOTIFICATION_CENTER:notify("decrement_player_health", self.damage)

        if collidedObject.y + collidedObject.yOffset + self.pushback <= PLAYER_AREA_HEIGHT then
          collidedObject:moveBy(0, self.pushback)
        end
      end
    end
    self:remove()
  elseif actualY > PLAYER_AREA_HEIGHT + self.projectileSize then
    self:remove()
  end
end

