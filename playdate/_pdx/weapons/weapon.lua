import "consts"
import "weapons/projectile"


local pd <const> = playdate
local gfx <const> = playdate.graphics


class("Weapon").extends(Object)

function Weapon:init(name, projectileImage, cooldown, gunPositions, mountingPoint, speed, damage, pushback, friendly)
  self.name = name

  if friendly then
    self.cooldown = cooldown
  else
    self.cooldown = cooldown * 2
  end

  self:createCooldownTimer()

  self.speed = speed
  self.damage = damage
  self.pushback = pushback

  self.gunPositions = gunPositions
  self.mountingPoint = mountingPoint
  self.friendly = friendly

  self.halted = false
  self.canShoot = true

  self.projectileImage = projectileImage
end

function Weapon:createCooldownTimer()
  self.cooldownTimer = pd.timer.performAfterDelay(self.cooldown, function()
    self:createCooldownTimer()
    self.canShoot = true
  end)
end

function Weapon:shoot(originX, originY)
  if self.halted then
    return
  end

  if not self.canShoot then
    return
  end

  self.canShoot = false

  for i, gunPosition in ipairs(self.gunPositions) do
    local x, y =  self.mountingPoint[1] + gunPosition[1],  self.mountingPoint[2] + gunPosition[2]

    Projectile(self.projectileImage, originX + x, originY + y, self.speed, self.damage, self.pushback, self.friendly)
  end
end
