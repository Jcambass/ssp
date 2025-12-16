
!if PLAYDATE then
local pd <const> = playdate
local gfx <const> = playdate.graphics
!else
local pd = playdate
local gfx = playdate.graphics
!end

class('SceneManager').extends()

function SceneManager:init()
    self.transitionTime = 1000 
    self.transitioning = false
end

function SceneManager:switchScene(scene, ...)
    
    if self.transitioning then
        return
    end

    self.transitioning = true

    self.newScene = scene
    local args = {...}
    self.sceneArgs = args

    self:startTransition()
end

function SceneManager:loadNewScene()
    self:cleanupScene()
    !if PLAYDATE then
    self.newScene(table.unpack(self.sceneArgs))
    !else
    self.newScene(unpack(self.sceneArgs))
    !end
end

function SceneManager:cleanupScene()
    gfx.sprite.removeAll()
    self:removeAllTimers()
    gfx.setDrawOffset(0, 0)
    NOTIFICATION_CENTER:unsubscribeAll()
end

function SceneManager:startTransition()
    local allSprites = gfx.sprite.getAllSprites()
    for i=1,#allSprites do
        allSprites[i].halted = true
    end

    local transitionTimer = self:fadeTransition(0, 1, function()
        self:loadNewScene()

        transitionTimer = self:fadeTransition(1, 0, function()
            self.transitioning = false
            -- Temp fix to resolve bug with sprite artifacts/smearing after transition
            for i=1,#allSprites do
                allSprites[i]:markDirty()
            end
        end)
    end)
end

function SceneManager:wipeTransition(startValue, endValue)
    local transitionSprite = self:createTransitionSprite()
    transitionSprite:setClipRect(0, 0, startValue, 240)

    local transitionTimer = pd.timer.new(self.transitionTime, startValue, endValue, pd.easingFunctions.inOutCubic)
    transitionTimer.updateCallback = function(timer)
        transitionSprite:setClipRect(0, 0, timer.value, 240)
    end
    return transitionTimer
end

function SceneManager:fadeTransition(startValue, endValue, endedCallback)
    local transitionSprite = self:createTransitionSprite()
    transitionSprite:setImage(self:getFadedImage(startValue))

    local transitionTimer = pd.timer.new(self.transitionTime, startValue, endValue, pd.easingFunctions.inOutCubic)
    transitionTimer.updateCallback = function(timer)
        img = self:getFadedImage(timer.value)
        transitionSprite:setImage(img)
    end

    transitionTimer.timerEndedCallback = function()
        -- Final update to ensure correct end value
        -- Technically shouldn't be needed, but we seem to run into issues without it.
        -- Might be related to floating point precision?
        transitionSprite:setImage(self:getFadedImage(endValue))
        -- Remove our transition sprite
        transitionSprite:remove()
        if endedCallback then
            endedCallback()
        end
    end
    return transitionTimer
end

function SceneManager:getFadedImage(alpha)
    local fadedImage = gfx.image.new(400, 240, gfx.kColorClear)
    gfx.pushContext(fadedImage)
        local filledRect = gfx.image.new(400, 240, gfx.kColorWhite)
        filledRect:drawFaded(0, 0, alpha, gfx.image.kDitherTypeBayer8x8)
    gfx.popContext()
    return fadedImage
end


function SceneManager:createTransitionSprite()
    local filledRect = gfx.image.new(400, 240, gfx.kColorBlack)
    local transitionSprite = gfx.sprite.new(filledRect)
    transitionSprite:moveTo(200, 120)
    transitionSprite:setZIndex(10000)
    transitionSprite:setIgnoresDrawOffset(true)
    transitionSprite:add()
    return transitionSprite
end

function SceneManager:removeAllTimers()
    local allTimers = pd.timer.allTimers()
    for _, timer in ipairs(allTimers) do
        timer:remove()
    end
end