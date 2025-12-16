import "consts"
import "scenes/gameScene"
import "scenes/leaderboardScene"
import "highScore"
import "CoreLibs/keyboard"

!if PLAYDATE then
local pd <const> = playdate
local gfx <const> = playdate.graphics
!else
local pd = playdate
local gfx = playdate.graphics
!end

class('GameOverScene').extends(gfx.sprite)

function GameOverScene:init(score)
  self.score = score
  self.newHighScore = false

  self:add()

  local isHighScore, highScorePlace = IsNewHighScore(self.score)

  if isHighScore then
    self.newHighScore = true
    self.highScorePlace = highScorePlace
  end

  self:drawGameOver()
end

function GameOverScene:drawGameOver()
  local text = "Game Over!\n\nPress the B button to restart"

  if self.newHighScore then
    text = "Game Over!\n\nNew High Score at rank " .. self.highScorePlace .. "!\n\n" .. self.score .. "\n\nPress the B button to continue"
  end

  local gameOverImage = gfx.image.new(gfx.getTextSize(text))
  gfx.pushContext(gameOverImage)
    gfx.drawText(text, 0, 0)
  gfx.popContext()
  local gameOverSprite = gfx.sprite.new(gameOverImage)
  gameOverSprite:moveTo(200, 120)

  gameOverSprite:add()
end

function GameOverScene:update()
  if pd.buttonIsPressed(pd.kButtonB) then
    if self.newHighScore then
      self:promptForName()
    else
      SCENE_MANAGER:switchScene(GameScene)
    end
  end
end

function GameOverScene:redrawNameSprite(name)
  local img = gfx.image.new(400, 240)
  gfx.pushContext(img)
    gfx.fillRect(0, 0, 400, 240)
    gfx.drawText("Enter your name:", 20, 100)
    gfx.drawText(name, 20, 130)
  gfx.popContext()

  self.nameGameOverSprite:setImage(img)
end

function GameOverScene:promptForName()
  pd.keyboard.keyboardDidShowCallback = function()
    self.nameGameOverSprite = gfx.sprite.new()
    self.nameGameOverSprite:setSize(400, 240)
    self.nameGameOverSprite:moveTo(200, 120)

    self:redrawNameSprite("")
    self.nameGameOverSprite:add()
  end

  pd.keyboard.textChangedCallback = function()
    if not self.nameGameOverSprite then
      return
    end

    local txt = pd.keyboard.text
    if txt:len() > 4 then
      pd.keyboard.text = string.sub(txt ,1,4)
    end

    self:redrawNameSprite(pd.keyboard.text)
  end

  pd.keyboard.keyboardWillHideCallback = function(selectedOk)
    if self.nameGameOverSprite then
      self.nameGameOverSprite:remove()
    end

    if not selectedOk then
      return
    end

    if self:isBlankString(pd.keyboard.text) then
      return
    end

    SetHighScoreAt(self.score, pd.keyboard.text, self.highScorePlace)
    setupMenuImage()
    SCENE_MANAGER:switchScene(LeaderboardScene)
  end

  pd.keyboard.show()
end

function GameOverScene:isBlankString(str)
  if str == nil then
    return true
  end

  if str == "" then
    return true
  end

  i, j = string.find(str, "%s+")
  return i == 1 and j == string.len(str)
end