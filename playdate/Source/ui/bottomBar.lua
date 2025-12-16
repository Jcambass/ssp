-- import "scenes/gameOverScene" -- Circular dependency, GameOverScene is global
import "screenShake"

!if PLAYDATE then
local pd <const> = playdate
local gfx <const> = playdate.graphics
!else
local pd = playdate
local gfx = playdate.graphics
!end

class("BottomBar").extends(gfx.sprite)

function BottomBar:init(barHeight)
  BottomBar.super.init(self)
  
  self.barHeight = barHeight
  self.barWidth = 400
  self.bottomScreen = 240

  self:setSize(self.barWidth, self.barHeight)
  self:moveTo(self.barWidth/2, self.bottomScreen - barHeight/2)
  self:setZIndex(Layers.UI)

  self.score = 0
  self.health = 100
  self.earthHealth = 1000

  self:drawBar()
  self:add()

  NOTIFICATION_CENTER:subscribe("decrement_earth_health", function(earthDamage)
    self:decrementEarthHealth(earthDamage)
  end)

  NOTIFICATION_CENTER:subscribe("decrement_player_health", function(playerDamage)
    self:decrementPlayerHealth(playerDamage)
  end)

  NOTIFICATION_CENTER:subscribe("increment_player_health", function(gainedHealth)
    self:incrementPlayerHealth(gainedHealth)
  end)

  NOTIFICATION_CENTER:subscribe("increment_score", function(scorePoints)
    self:incrementScore(scorePoints)
 end)
end

function BottomBar:decrementEarthHealth(amount)
  self.earthHealth = self.earthHealth - amount
  if self.earthHealth < 0 then
    self.earthHealth = 0
  end

  self:drawBar()

  if self.earthHealth <= 0 then
    SCENE_MANAGER:switchScene(GameOverScene, self.score)
  end
end

function BottomBar:decrementPlayerHealth(amount)
  self.health = self.health - amount
  if self.health < 0 then
    self.health = 0
  end

  self:drawBar()

  if self.health <= 0 then
    SCENE_MANAGER:switchScene(GameOverScene, self.score)
    return
  end

  screenShake(500, 5)
end

function BottomBar:incrementPlayerHealth(amount)
  self.health = self.health + amount
  if self.health > 100 then
    self.health = 100
  end

  self:drawBar()
end

function BottomBar:incrementScore(amount)
  self.score = self.score + amount
  self:drawBar()

  NOTIFICATION_CENTER:notify("score_updated", self.score)
end


function BottomBar:drawBar()
  local image = gfx.image.new(self.barWidth, self.barHeight)
  gfx.pushContext(image)
    gfx.setImageDrawMode(gfx.kDrawModeCopy)
    gfx.setColor(gfx.kColorWhite)
    local imgWidth, imgHeight = image:getSize()
    gfx.fillRoundRect(0, 0, imgWidth, imgHeight, 5)
    gfx.drawText("Earth Health: " .. self.earthHealth, 10, 1)
    gfx.drawText("Health: " .. self.health, 180, 1)
    gfx.drawText("Score: " .. self.score, 280, 1)
  gfx.popContext()
  self:setImage(image)
end