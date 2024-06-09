local component = require("component")

local controllerNames = {}
local controllerAdrs = {}

for address, name in component.list("controller", false) do
    table.insert(controllerNames, component.proxy(component.get(address)).getControllerName())
    table.insert(controllerAdrs, component.get(address))
end


function table_contains(tbl, x)
    found = false
    for _, v in pairs(tbl) do
        if v == x then
            found = true
        end
    end
    return found
end

function findIndexInTable(table, x)
    for i, value in ipairs(table) do
        if value == x then
            return i
        end
    end
    return nil
end

local function getAddress(name)
    if table_contains(controllerNames, name) then
        for var = #controllerNames, 1, -1 do
            if (controllerNames[var] == name) then
                return controllerAdrs[var]
            end
        end
    else
        table.insert(controllerNames, name)
        table.insert(controllerAdrs, "NotConnected")
        return "NotConnected"
    end
end

local controllers = {}

function controllers.isConnected(name)
    local var = findIndexInTable(controllerNames, name)
    if (controllerAdrs[var] == "NotConnected") then
        return false
    end
    return true
end

function controllers.printTable()
    for var = #controllerNames, 1, -1 do
        print(controllerNames[var])
        print(controllerAdrs[var])
    end
end

-- New SignalCraft Signals
controllers.Signals = component.proxy(getAddress("Signals")) -- Signals

-- Switches
controllers.Switches = component.proxy(getAddress("Switches")) -- Switches

return controllers
