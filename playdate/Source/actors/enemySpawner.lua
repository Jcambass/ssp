import "consts"
import "actors/enemy"
import "weapons/stomp"
import "weapons/grim"
import "weapons/hammer"
import "weapons/ratata"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local bigShipImage = gfx.image.new("Images/ships/BigShip-white")
assert( bigShipImage ) -- make sure the image was where we thought

local darkLordImage = gfx.image.new("Images/ships/darkLord-white")
assert( darkLordImage ) -- make sure the image was where we thought

local spaceCrusaderImage = gfx.image.new("Images/ships/spaceCrusader-white")
assert( spaceCrusaderImage ) -- make sure the image was where we thought

local trespasserImage = gfx.image.new("Images/ships/trespasser-white")
assert( trespasserImage ) -- make sure the image was where we thought

local playerImage = gfx.image.new("Images/player")
assert( playerImage ) -- make sure the image was where we thought
local playerWidth, playerHeight = playerImage:getSize()

function randomEnemy()
  local enemyIndex = math.random(1, 4)
  if enemyIndex == 1 then
    return {
      image = bigShipImage,
      health = 100,
      speed = 0.3,
      playerDamage = 35,
      earthDamage = 120,
      scorePoints = 120,
      weaponClass = Stomp,
    }
  elseif enemyIndex == 2 then
    return {
      image = darkLordImage,
      health = 250,
      speed = 0.3,
      playerDamage = 75,
      earthDamage = 250,
      scorePoints = 250,
      weaponClass = Grim,
    }
  elseif enemyIndex == 3 then
    return {
      image = spaceCrusaderImage,
      health = 80,
      speed = 0.3,
      earthDamage = 180,
      playerDamage = 55,
      scorePoints = 180,
      weaponClass = Hammer,
    }
  else
    return {
      image = trespasserImage,
      health = 30,
      speed = 0.3,
      earthDamage = 35,
      playerDamage = 13,
      scorePoints = 35,
      -- No weaponClass
    }
  end
end

function startEnemySpawner()
  createEnemyTimer()
end

function createEnemyTimer()
  local spawnTime = math.random(3000, 5000)
  pd.timer.performAfterDelay(spawnTime, function()
    createEnemyTimer()
    spawnEnemy()
  end)
end

function spawnEnemy()
  local data = randomEnemy()
  local spawnPosition = math.random(playerWidth, PLAYER_AREA_WIDTH - playerWidth)

  local x, y = data.image:getSize()
  Enemy(spawnPosition, -(y/2), data)
end