
!if PLAYDATE then
local pd <const> = playdate
local gfx <const> = playdate.graphics
!else
local pd = playdate
local gfx = playdate.graphics
!end

local fadedRects = nil
local function initializeFadedRects()
    if fadedRects then return end
    
    print("=== Initializing faded rects ===")
    fadedRects = {}
    for i=0,1,0.01 do
        local fadedImage = gfx.image.new(400, 240)
        gfx.pushContext(fadedImage)
            local filledRect = gfx.image.new(400, 240, gfx.kColorBlack)
            filledRect:drawFaded(0, 0, i, gfx.image.kDitherTypeBayer8x8)
        gfx.popContext()
        
        -- Debug: Sample some pixels to verify colors
        if i == 0 or i == 0.5 or i == 1.0 then
            print(string.format("Alpha %.2f - Sampling pixels:", i))
            -- Sample a few pixels across the image
            for py = 0, 240, 60 do
                for px = 0, 400, 100 do
                    local color = fadedImage:sample(px, py)
                    local colorName = "UNKNOWN"
                    if color == gfx.kColorWhite then
                        colorName = "WHITE"
                    elseif color == gfx.kColorBlack then
                        colorName = "BLACK"
                    elseif color == gfx.kColorClear then
                        colorName = "CLEAR/TRANSPARENT"
                    end
                    print(string.format("  Pixel (%d,%d): %s (value=%s)", px, py, colorName, tostring(color)))
                end
            end
        end
        
        fadedRects[math.floor(i * 100)] = fadedImage
    end
    fadedRects[100] = gfx.image.new(400, 240, gfx.kColorBlack)
    print("=== Faded rects initialized ===")
end

class('SceneManager').extends()

function SceneManager:init()
    self.transitionTime = 1000
    self.transitioning = false
end

function SceneManager:switchScene(scene, ...)
    initializeFadedRects() -- Initialize on first use
    
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
    print("loadNewScene called")
    self:cleanupScene()
    print("Scene cleaned up, creating new scene")
    !if PLAYDATE then
    self.newScene(table.unpack(self.sceneArgs))
    !else
    self.newScene(unpack(self.sceneArgs))
    !end
    print("New scene created")
end

function SceneManager:cleanupScene()
    gfx.sprite.removeAll()
    self:removeAllTimers()
    gfx.setDrawOffset(0, 0)
    NOTIFICATION_CENTER:unsubscribeAll()
end

function SceneManager:startTransition()
    print("startTransition called")
    local allSprites = gfx.sprite.getAllSprites()
    print("Halting " .. #allSprites .. " sprites")
    for i=1,#allSprites do
        allSprites[i].halted = true
    end

    local transitionTimer = self:fadeTransition(0, 1)
    print("Created fade transition timer")
    --local transitionTimer = self:wipeTransition(0, 400)

    transitionTimer.timerEndedCallback = function()
        print("First fade complete, loading new scene")
        self:loadNewScene()
        transitionTimer = self:fadeTransition(1, 0)
        print("Created second fade transition timer")
        -- transitionTimer = self:wipeTransition(400, 0)
        transitionTimer.timerEndedCallback = function()
            print("Second fade complete, transition done")
            self.transitioning = false
            self.transitionSprite:remove()
            -- Temp fix to resolve bug with sprite artifacts/smearing after transition
            for i=1,#allSprites do
                allSprites[i]:markDirty()
            end
        end
    end
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

function SceneManager:fadeTransition(startValue, endValue)
    local transitionSprite = self:createTransitionSprite()
    transitionSprite:setImage(self:getFadedImage(startValue))

    local transitionTimer = pd.timer.new(self.transitionTime, startValue, endValue, pd.easingFunctions.inOutCubic)
    transitionTimer.updateCallback = function(timer)
        img = self:getFadedImage(timer.value)
        if img then
            transitionSprite:setImage(img)
            -- Debug: Log transition state periodically
            if math.random() < 0.05 then -- 5% chance to log
                print(string.format("Transition alpha: %.2f, Image: %s", timer.value, tostring(img)))
                -- Sample center pixel of the transition image
                local centerColor = img:sample(200, 120)
                local colorName = "UNKNOWN"
                if centerColor == gfx.kColorWhite then
                    colorName = "WHITE (UNEXPECTED!)"
                elseif centerColor == gfx.kColorBlack then
                    colorName = "BLACK"
                elseif centerColor == gfx.kColorClear then
                    colorName = "CLEAR/TRANSPARENT"
                end
                print(string.format("  Center pixel color: %s", colorName))
            end
        end
    end
    return transitionTimer
end

function SceneManager:getFadedImage(alpha)
    initializeFadedRects()
    return fadedRects[math.floor(alpha * 100)]
end


function SceneManager:createTransitionSprite()
    local filledRect = gfx.image.new(400, 240, gfx.kColorBlack)
    local transitionSprite = gfx.sprite.new(filledRect)
    transitionSprite:moveTo(200, 120)
    transitionSprite:setZIndex(10000)
    transitionSprite:setIgnoresDrawOffset(true)
    transitionSprite:add()
    self.transitionSprite = transitionSprite
    return transitionSprite
end

function SceneManager:removeAllTimers()
    local allTimers = pd.timer.allTimers()
    for _, timer in ipairs(allTimers) do
        timer:remove()
    end
end