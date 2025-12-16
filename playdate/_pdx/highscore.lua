local pd <const> = playdate
local gfx <const> = playdate.graphics

function GetHighScores()
  local t = pd.datastore.read("highscores")

  if t == nil then
    t = {
      {score = 0, name = "-"},
      {score = 0, name = "-"},
      {score = 0, name = "-"},
    }
  end

  return t
end

function IsNewHighScore(score)
  local oldHighScores = GetHighScores()

  local newHighScoreAt = 0

  for i, hs in ipairs(oldHighScores) do
    if score > hs.score then
      newHighScoreAt = i
      break
    end
  end

  if newHighScoreAt == 0 then
    return false, 0
  end

  return true, newHighScoreAt
end

function SetHighScoreAt(score, name, newHighScoreAt)
  local oldHighScores = GetHighScores()
  local newHighScores = {}

  if newHighScoreAt == 1 then
    newHighScores[1] = {score = score, name = name}
    newHighScores[2] = oldHighScores[1]
    newHighScores[3] = oldHighScores[2]
  elseif newHighScoreAt == 2 then
    newHighScores[1] = oldHighScores[1]
    newHighScores[2] = {score = score, name = name}
    newHighScores[3] = oldHighScores[2]
  else
    newHighScores[1] = oldHighScores[1]
    newHighScores[2] = oldHighScores[2]
    newHighScores[3] = {score = score, name = name}
  end

  pd.datastore.write(newHighScores, "highscores")
end
