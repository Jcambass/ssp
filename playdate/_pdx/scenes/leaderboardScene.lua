import "consts"
import "scenes/gameScene"
import "highScore"


local pd <const> = playdate
local gfx <const> = playdate.graphics


local leaderboardImage = gfx.image.new("Images/leaderboard")
assert(leaderboardImage) -- make sure the image was where we thought

class('LeaderboardScene').extends(gfx.sprite)

function LeaderboardScene:init()
  local text = "Press the B button\nto restart"

  local highScores = GetHighScores()
  local img = leaderboardImage:copy()
  gfx.pushContext(img)
    gfx.setColor(gfx.kColorBlack)

    if highScores[1].score ~= 0 then
      gfx.drawText(highScores[1].name .. ": " .. highScores[1].score, 60, 60)
    end
    if highScores[2].score ~= 0 then
      gfx.drawText(highScores[2].name .. ": " .. highScores[2].score, 60, 108)
    end
    if highScores[3].score ~= 0 then
      gfx.drawText(highScores[3].name .. ": " .. highScores[3].score, 60, 157)
    end

    gfx.drawText(text, 220, 100)

  gfx.popContext()

  self:setImage(img)
  self:moveTo(200, 120)

  self:add()
end

function LeaderboardScene:update()
  if pd.buttonIsPressed(pd.kButtonB) then
    SCENE_MANAGER:switchScene(GameScene)
  end
end
