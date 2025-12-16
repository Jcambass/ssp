-- Playdate keyboard module for Love2D
-- Implements actual keyboard text input for Love2D

local module = {}
playdate.keyboard = module

-- Keyboard state
module.text = ""
local isVisible = false
local initialText = ""

-- Callbacks
module.keyboardDidShowCallback = nil
module.textChangedCallback = nil
module.keyboardWillHideCallback = nil
module.keyboardAnimatingCallback = nil

function module.show(text)
  if isVisible then
    return
  end
  
  isVisible = true
  initialText = text or ""
  module.text = initialText
  
  -- Enable text input
  love.keyboard.setTextInput(true)
  
  -- Call the callback if set
  if module.keyboardDidShowCallback then
    module.keyboardDidShowCallback()
  end
  
  -- Trigger initial textChangedCallback if text was provided
  if text and module.textChangedCallback then
    module.textChangedCallback()
  end
end

function module.hide()
  if not isVisible then
    return
  end
  
  isVisible = false
  
  -- Disable text input
  love.keyboard.setTextInput(false)
  
  -- Call callback with selectedOk = true
  local callback = module.keyboardWillHideCallback
  if callback then
    callback(true)
  end
  
  -- Clear callbacks after hiding to match Playdate behavior
  module.keyboardDidShowCallback = nil
  module.textChangedCallback = nil
  module.keyboardWillHideCallback = nil
  module.keyboardAnimatingCallback = nil
end

function module.isVisible()
  return isVisible
end

function module.setCapitalizationBehavior(behavior)
  -- Not implemented for Love2D
end

-- Internal function to handle text input from Love2D
function module._handleTextInput(text)
  if not isVisible then
    return
  end
  
  module.text = module.text .. text
  
  if module.textChangedCallback then
    module.textChangedCallback()
  end
end

-- Internal function to handle backspace
function module._handleBackspace()
  if not isVisible then
    return
  end
  
  if #module.text > 0 then
    module.text = module.text:sub(1, -2)
    
    if module.textChangedCallback then
      module.textChangedCallback()
    end
  end
end

-- Internal function to handle keyboard key presses
function module._handleKeyPressed(key)
  if not isVisible then
    return
  end
  
  if key == "return" or key == "kpenter" then
    module.hide()
  elseif key == "escape" then
    module.text = initialText
    isVisible = false
    love.keyboard.setTextInput(false)
    
    -- Call callback with selectedOk = false
    local callback = module.keyboardWillHideCallback
    if callback then
      callback(false)
    end
    
    -- Clear callbacks after canceling to match Playdate behavior
    module.keyboardDidShowCallback = nil
    module.textChangedCallback = nil
    module.keyboardWillHideCallback = nil
    module.keyboardAnimatingCallback = nil
  elseif key == "backspace" then
    module._handleBackspace()
  end
end

return module
