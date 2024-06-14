local utils = {}
local Config = require("config")
local internet = require("internet")
local json = require("json")
local controllers = require("controllers")

-- Function: utils.calcSwitchTextPos
-- Description: Calculate the position of the switch text
-- Parameters: switchTbl - table containing the switch data
-- Returns: table containing the x and y position of the switch text
utils.calcSwitchTextPos = function(switchTbl)
    local result = {}
    local x, y = switchTbl[1], switchTbl[2]

    if switchTbl[3] == "╗" or switchTbl[4] == "╗" then
        y = switchTbl[2] - 1
    elseif switchTbl[3] == "╝" or switchTbl[4] == "╝" then
        y = switchTbl[2] + 1
    elseif switchTbl[3] == "╚" or switchTbl[4] == "╚" then
        y = switchTbl[2] + 1
    elseif switchTbl[3] == "╔" or switchTbl[4] == "╔" then
        y = switchTbl[2] - 1
    end
    x = switchTbl[5]:len() == 1 and x or x - 1

    result["x"] = x
    result["y"] = y
    return result
end

-- Function: utils.calcSignalTextPos
-- Description: Calculate the position of the signal text
-- Parameters: signalTbl - table containing the signal data
-- Returns: table containing the x and y position of the signal text
utils.calcSignalTextPos = function(signalTbl)
    local result = {}
    local x, y = signalTbl[1], signalTbl[2]

    if signalTbl[4] == "<" or signalTbl[4] == "◀" or signalTbl[4] == "◁" then
        x = signalTbl[1] - (string.len(signalTbl[3]) / 2)
        if string.len(signalTbl[3]) % 2 == 0 then x = x + 1 end
        y = signalTbl[2] - 1
    elseif signalTbl[4] == ">" or signalTbl[4] == "▶" or signalTbl[4] == "▷" then
        x = signalTbl[1] - (string.len(signalTbl[3]) / 2)
        if string.len(signalTbl[3]) % 2 == 0 then x = x + 1 end
        y = signalTbl[2] + 1
    elseif signalTbl[4] == "^" or signalTbl[4] == "▲" or signalTbl[4] == "△" then
        x = signalTbl[1] + 1
        y = signalTbl[2]
    elseif signalTbl[4] == "V" or signalTbl[4] == "▼" or signalTbl[4] == "▽" then
        x = signalTbl[1] - string.len(signalTbl[3])
        y = signalTbl[2]
    end

    result["x"] = x
    result["y"] = y
    return result
end

-- Function: string.split
-- Description: Splits a string by a separator
-- Parameters: inputstr - the string to split
--             sep - the separator
-- Returns: table containing the split strings
function string.split(inputstr, sep)
    if sep == nil then
       sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
       table.insert(t, str)
    end
    return t
end

-- Function: utils.debugPrint
-- Description: Logs a message to the log file if debug is enabled
-- Parameters: message - the message to print
utils.debugPrint = function(message)
    if not Config.Debug then return end

    local file = io.open("log.txt", "a")
    if not file then
        print("Failed to open log file")
        return os.exit()
    end
    local rawTime = json.decode(internet.request("https://worldtimeapi.org/api/timezone/Europe/Prague")())["datetime"]
    local time = string.split(rawTime, "T")[1] .. " " .. string.split(string.split(rawTime, "T")[2], ".")[1]
    file:write(time .. "  " .. tostring(message) .. "\n")
    file:close()
end

-- Define connected controllers
local switchesConnected = controllers.isConnected("Switches")
local signalsConnected  = controllers.isConnected("Signals")
local crossingsConnected = controllers.isConnected("Crossings")

-- Function: utils.resetLayout
-- Description: Resets the switches and signals according to the default layout
utils.resetLayout = function()
    if switchesConnected then
        for _, switch in pairs(Config.Switches) do
            if switch[3] == "╗" or switch[3] == "╝" or switch[3] == "╚" or switch[3] == "╔" or switch[3] == "╚" then
                controllers.Switches.setAspect(switch[5], 1)
            else
                controllers.Switches.setAspect(switch[5], 5)
            end
        end
    end
    
    if signalsConnected then controllers.Signals.setEveryState("Stuj") end
end

-- Function: utils.toggleSwitch
-- Description: Toggles the switch
-- Parameters: switchName - the name of the switch
utils.toggleSwitch = function(switchName)
    if not switchesConnected then return end
    if controllers.Switches.getAspect(switchName) == 1 then
        controllers.Switches.setAspect(switchName, 5)
    else
        controllers.Switches.setAspect(switchName, 1)
    end
end

utils.toggleCrossing = function(switchName)
    if not crossingsConnected then return end
    if controllers.Crossings.getAspect(switchName) == 5 then
        controllers.Crossings.setAspect(switchName, 1)
    else
        controllers.Crossings.setAspect(switchName, 5)
    end
end

-- Function: utils.sendStateToExpectSig
-- Description: Sends the state of the signal to the expect signal
-- Parameters: signalName - the name of the signal
--             state - the state of the signal
utils.sendStateToExpectSig = function(signalName, state)
    if not signalsConnected then return end

    if state == "Stuj" then
        state = "Vystraha"
    elseif state == "PN" then
        state = "Vystraha"
    elseif state == "Vystraha" then
        state = "Volno"
    elseif state == "Volno" then
        state = "Volno"
    elseif string.sub(state, 1, 3) == "R40" then
        state = "Ocek40"
    elseif string.sub(state, 1, 3) == "R60" then
        state = "Ocek60"
    elseif string.sub(state, 1, 3) == "R80" then
        state = "Ocek80"
    elseif state.sub(state, 1, 4) == "Ocek" then
        state = "Volno"
    elseif state.sub(state, 1, 4) == "Opak" then
        state = state.sub(state, 5)
    else
        state = "Vystraha"
    end

    controllers.Signals.setState("Pr" .. signalName, state)
end

-- Simple shallow copy of a table
function table.clone(org)
    return {table.unpack(org)}
end

return utils, table.clone, string.split
