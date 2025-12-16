-- Playdate keyboard module for Love2D
-- This is a stub implementation for Love2D - actual keyboard not shown

local module = {}
playdate.keyboard = module

-- Keyboard state
module.text = ""
local isVisible = false

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
  module.text = text or ""
  
  -- In Love2D, we'll use a simple text input instead of showing keyboard
  -- Call the callback if set
  if module.keyboardDidShowCallback then
    module.keyboardDidShowCallback()
  end
  
  -- For Love2D, we'll just simulate immediate acceptance with empty text
  -- In a real implementation, you'd want to capture keyboard input
  print("[Keyboard] Simulating keyboard input in Love2D - Press Enter to accept")
end

function module.hide()
  if not isVisible then
    return
  end
  
  isVisible = false
  
  -- Call callback with selectedOk = true
  if module.keyboardWillHideCallback then
    module.keyboardWillHideCallback(true)
  end
end

function module.isVisible()
  return isVisible
end

function module.setCapitalizationBehavior(behavior)
  -- Not implemented for Love2D
end

-- Helper function to update text (for Love2D keyboard input)
function module.updateText(newText)
  module.text = newText
  if module.textChangedCallback then
    module.textChangedCallback()
  end
end

return module
