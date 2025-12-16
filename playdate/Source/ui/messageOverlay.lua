import "consts"

!if PLAYDATE then
local pd <const> = playdate
local gfx <const> = playdate.graphics
!else
local pd = playdate
local gfx = playdate.graphics
!end

class("MessageOverlay").extends(gfx.sprite)

function MessageOverlay:init(x, y)
  MessageOverlay.super.init(self)
  
  self:moveTo(x, y)
  self:setZIndex(Layers.UI)
  self:add()

  NOTIFICATION_CENTER:subscribe("display_message", function(msg, duration)
    self:display(msg, duration)
  end)

  self.hideTimer = nil
end

function MessageOverlay:display(msg, duration)
  local textWidth, textHeight = gfx.getTextSize(msg)
  local image = gfx.image.new(textWidth + 10, textHeight + 2)
  gfx.pushContext(image)
    gfx.setImageDrawMode(gfx.kDrawModeCopy)
    gfx.setColor(gfx.kColorWhite)
    local imgWidth, imgHeight = image:getSize()
    gfx.fillRoundRect(0, 0, imgWidth, imgHeight, 5)
    gfx.drawText(msg, 5, 3)
  gfx.popContext()
  self:setImage(image)

  if self.hideTimer then
    self.hideTimer:remove()
  end

  self.hideTimer = pd.timer.new(duration, function()
    self:hide()
  end)
end

function MessageOverlay:hide()
  self:setImage(nil)
end
