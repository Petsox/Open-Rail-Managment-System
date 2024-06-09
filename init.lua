-- Imports
local GUI = require("grapes.GUI")
local term = require("term")
local config = require("config")
local utils = require("utils")
local text = require("text")
local controllers = require("controllers")

-- Global tables
SwitchTexts = {}
local settingsWindow = nil

-- Create workspace
local workspace = GUI.workspace()

-- Draw background
workspace:addChild(GUI.panel(1, 1, workspace.width, workspace.height, 0x000000))

-- Draw title
workspace:addChild(GUI.label(1, 1, workspace.width, workspace.height, 0xFFFFFF, "Open Rail Management System"):setAlignment(GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_TOP))
workspace:addChild(GUI.label(1, 1, workspace.width, workspace.height, 0xFFFFFF, "By Petsox and tpeterka1"):setAlignment(GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_BOTTOM))

-- Draw exit button
local exitBtn = workspace:addChild(GUI.label(155, 50, 6, 1, 0xFFFFFF, "[Exit]"))
exitBtn.eventHandler = function(workspace, object, event)
    if event == "touch" then
        utils.resetLayout()
        term.clear()
        os.exit()
    end
end

-- Draw settings 
local settBtn = workspace:addChild(GUI.label(1, 50, 10, 1, 0xFFFFFF, "[Settings]"))
settBtn.eventHandler = function(workspace, object, event)
    if event == "touch" then
        if not settingsWindow then
            settingsWindow = workspace:addChild(GUI.titledWindow(workspace.width/2, workspace.height/2, 21, 20, "Settings", true))

            -- Switch number toggle
            local switchNumberStg = settingsWindow:addChild(GUI.button(3, 3, 16, 3, 0x19ED15, 0x000000, 0xED1515, 0x000000, "Switch Numbers"))
            switchNumberStg.switchMode = true
            switchNumberStg.animated = false
            if workspace.children[SwitchTexts[1]].hidden then switchNumberStg.pressed = true end
            switchNumberStg.onTouch = function()
                for _, switchText in pairs(SwitchTexts) do
                    workspace.children[switchText].hidden = not workspace.children[switchText].hidden
                end
                workspace:draw()
            end


            workspace:draw()
            settingsWindow.actionButtons.close.onTouch = function()
                settingsWindow:remove()
                settingsWindow = nil
            end
        end
    end
end

-- Import tracks
for _, track in pairs(config.Tracks) do
    workspace:addChild(GUI.text(track[1], track[2], 0xFFFFFF, text.trim(track[3]) or ""))
end

-- Import switches
for _, switch in pairs(config.Switches) do
    local newSwitch = workspace:addChild(GUI.text(switch[1], switch[2], 0xFFFFFF, text.trim(switch[3]) or ""))
    newSwitch.state = false
    newSwitch.eventHandler = function(workspace, object, event)
        if event == "touch" then
            object.state = not object.state
            object.text = object.state and switch[4] or switch[3]
            utils.toggleSwitch(switch[5])
            workspace:draw()
        end
    end

    -- Create switch description
    local newSwitchTbl = table.clone(switch)
    newSwitchTbl[5] = (string.lower(string.sub(switch[5], 1, 2)) == "vy" and string.sub(switch[5], 3)) or text.trim(switch[5])
    local calculatedTextPos = utils.calcSwitchTextPos(newSwitchTbl)
    --utils.debugPrint("Cut switch text: " .. string.sub(switch[5], 1, 2))
    --utils.debugPrint("Switch text: " .. string.sub(switch[5], 3))
    local switchText = newSwitchTbl[5]
    table.insert(SwitchTexts, workspace:addChild(GUI.text(calculatedTextPos.x, calculatedTextPos.y, 0xFFFFFF, switchText)):indexOf())
end

-- Import signals
local signalMenus = {}
for _, signal in pairs(config.Signals) do
    local newSignal = workspace:addChild(GUI.button(signal[1], signal[2], 1, 1, 0x000000, 0xFFFFFF, 0x000000, 0xFFFFFF, signal[4]))
    signalMenus[signal[3]] = false
    newSignal.onTouch = function()
        if signalMenus[signal[3]] == false then
            signalMenus[signal[3]] = true
            local signalMenu = workspace:addChild(GUI.titledWindow(workspace.width - 30, workspace.height - 25, 30, 25, signal[3], true))
            signalMenu.actionButtons.close.onTouch = function()
                signalMenu:remove()
                signalMenus[signal[3]] = false
            end

            for i, state in pairs(controllers.Signals.getValidStatesForSignal(signal[3])) do
                local signalMenuState = signalMenu:addChild(GUI.button(5, i+1, 20, 1, 0x555555, 0x000000, 0x19ED15, 0x000000, state))
                signalMenuState.switchMode = true
                signalMenuState.animated = false
                if controllers.Signals.getState(signal[3]) == state then
                    signalMenuState.pressed = true
                end
                signalMenuState.onTouch = function()
                    for _, signalState in pairs(signalMenu.children) do
                        signalState.pressed = false
                    end
                    signalMenuState.pressed = true
                    controllers.Signals.setState(signal[3], state)
                    workspace:draw()
                end
            end
            workspace:draw()
        end
    end

    -- Create signal description
    local signalText = signal[3]
    local calculatedTextPos = utils.calcSignalTextPos(signal)
    --workspace:addChild(GUI.text(calculatedTextPos.x, calculatedTextPos.y, 0xFFFFFF, signalText))
end

-- Reset layout
utils.resetLayout()

workspace:draw()
workspace:start()