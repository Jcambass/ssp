-- Test what color a black filled rect is
local gfx = playdate.graphics
local filledRect = gfx.image.new(10, 10, gfx.kColorBlack)

-- Save it and check the actual pixel data
filledRect.data:getData():mapPixel(function(x, y, r, g, b, a)
  print(string.format("Pixel at (%d,%d): r=%f g=%f b=%f a=%f", x, y, r, g, b, a))
  if x == 0 and y == 0 then
    return r, g, b, a
  end
  return r, g, b, a
end)
