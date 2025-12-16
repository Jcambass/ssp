import "consts"
import "ui/messageOverlay"
import "ui/bottomBar"
import "actors/enemySpawner"
import "background/planetSpawner"
import "background/starSpawner"

!if PLAYDATE then
local pd <const> = playdate
local gfx <const> = playdate.graphics
!else
local pd = playdate
local gfx = playdate.graphics
!end

BOTTOM_BAR_HEIGHT = 20
PLAYER_AREA_HEIGHT = 240 - BOTTOM_BAR_HEIGHT
PLAYER_AREA_WIDTH = 400

class('GameScene').extends(gfx.sprite)

function GameScene:init()
  self.messageOverlay = MessageOverlay(200, 120)

  self.bottomBar = BottomBar(BOTTOM_BAR_HEIGHT)

  Player(200, 120)

  spawnInitialStars()
  startStarSpawner()
  startPlanetSpawner()
  startEnemySpawner(self)

  NOTIFICATION_CENTER:notify("display_message", "PROTECT EARTH AS LONG AS YOU CAN", 3000)

  self:add()
end

function GameScene:update()

end