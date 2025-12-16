import "consts"
import "background/planet"


local pd <const> = playdate
local gfx <const> = playdate.graphics



local planet1Image = gfx.image.new("Images/planet-1")
assert( planet1Image ) -- make sure the image was where we thought

local planet2Image = gfx.image.new("Images/planet-2")
assert( planet2Image ) -- make sure the image was where we thought

local planetSpawnTimer

function startPlanetSpawner()
  createPlanetTimer()
end

function randomPlanetImage()
  local planetIndex = math.random(1, 2)
  if planetIndex == 1 then
    return planet1Image
  else
    return planet2Image
  end
end

function createPlanetTimer()
  local spawnTime = math.random(10000, 20000)
  planetSpawnTimer = pd.timer.performAfterDelay(spawnTime, function()
    createPlanetTimer()
    spawnPlanet()
  end)
end

function spawnPlanet()
  local spawnPosition = math.random(10, PLAYER_AREA_WIDTH - 10)

  local img = randomPlanetImage()
  local x, y = img:getSize()

  Planet(spawnPosition, -(y/2), 0.4, img)
end
