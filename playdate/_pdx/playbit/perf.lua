local module = {}
playbit = playbit or {}
playbit.perf = module

local samples = {}
local frameSamples = {}



function module.beginSample(name)
  samples[name] = playdate.getCurrentTimeMilliseconds()
end

function module.endSample(name)
  local endTime = playdate.getCurrentTimeMilliseconds()
  local startTime = samples[name]
  print(name.."="..(endTime - startTime).."ms")
end

function module.beginFrameSample(name)

end

function module.endFrameSample(name)

end

function module.getFrameSample(name)

    return "0.000"

end

-- returns average FPS
function module.getFps()

  return math.floor(1.0 / playbit.time.avgDeltaTime())

end

function module.getMemory()
  return collectgarbage("count"), 2
end
