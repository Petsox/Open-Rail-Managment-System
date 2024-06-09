local gui = require("gui")
local component = require("component")
local controllers = require("controllers")
local Signal

--Connections

local spojSw = controllers.isConnected("Switches")
local spojSig = controllers.isConnected("Signals")


local function startswith(str, prefix)
  return str:sub(1, #prefix) == prefix
end

local SaS = {}

function SaS.reset()
  if spojSw then controllers.Switches.setEveryAspect(5) end

end

SaS.reset()


function SaS.ChangeState(signalName, state)
  oneLight.Volno(signalName)
  expectLights.Volno("Pr" .. signalName)
end

function SaS.switchFrom(switchName)
  controllers.Switches.setAspect(switchName, 5)
end

function SaS.switchTo(switchName)
  controllers.Switches.setAspect(switchName, 1)
end

return SaS