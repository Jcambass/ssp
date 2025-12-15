import "consts"
import "background/star"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local starImage = gfx.image.new("Images/star1-white")
assert( starImage ) -- make sure the image was where we thought

local starSpawnTimer

function startStarSpawner()
  createStarTimer()
end

function createStarTimer()
  local spawnTime = math.random(500, 1000)
  starSpawnTimer = pd.timer.performAfterDelay(spawnTime, function()
    createStarTimer()
    spawnStar()
  end)
end

function spawnStar()
  local spawnPosition = math.random(10, PLAYER_AREA_WIDTH - 10)
  local x, y = starImage:getSize()

  Star(spawnPosition, -(y/2), 0.25, starImage)
end

function spawnInitialStars()
  for i = 1, 15 do
    x = math.random(0, PLAYER_AREA_WIDTH)
    y = math.random(0, PLAYER_AREA_HEIGHT)
    Star(x, y, 0.25, starImage)
  end
end