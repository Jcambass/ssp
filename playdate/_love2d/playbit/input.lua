local module = {}
playbit = playbit or {}
playbit.input = module


--- Sets how Love2D inputs are mapped to Playdate's buttons. Both keyboard and joystick are supported.  
--- Prepend keyboard inputs with "kb_" and refer to Love2D's input list: https://love2d.org/wiki/KeyConstant  
--- Prepend joystick inputs with "js_" and refer to Love2D's input list:  https://love2d.org/wiki/GamepadButton.
---@param up string
---@param down string
---@param left string
---@param right string
---@param a string
---@param b string
function module.setKeyMap(up, down, left, right, a, b)
    
    
    
    
    
    
    playdate._buttonToKey.up = up
    playdate._buttonToKey.down = down
    playdate._buttonToKey.left = left
    playdate._buttonToKey.right = right
    playdate._buttonToKey.a = a
    playdate._buttonToKey.b = b
end

