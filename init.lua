-- Imports
local GUI = require("grapes.GUI")
local term = require("term")
local config = require("config")
local utils = require("utils")
local text = require("text")
local controllers = require("controllers")
local thread = require("thread")

-- Global tables
local SwitchTexts = {}
local SignalTexts = {}
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

            -- Signal description toggle
            local sigDescSetting = settingsWindow:addChild(GUI.button(3, 7, 16, 3, 0x19ED15, 0x000000, 0xED1515, 0x000000, "Signal Names"))
            sigDescSetting.switchMode = true
            sigDescSetting.animated = false
            if workspace.children[SignalTexts[1]].hidden then sigDescSetting.pressed = true end
            sigDescSetting.onTouch = function()
                for _, sigDesc in pairs(SignalTexts) do
                    workspace.children[sigDesc].hidden = not workspace.children[sigDesc].hidden
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
    local newTrack = workspace:addChild(GUI.text(track[1], track[2], 0xB2B2B2, text.trim(track[3]) or ""))
    local text = newTrack.text
    if text == "⦗" or text == "⦘" or text == "︹" or text == "︺" then
        newTrack.color = 0x0000FF
    end
end

-- Import switches
for _, switch in pairs(config.Switches) do
    -- Create switch button in layout
    local newSwitch = workspace:addChild(GUI.text(switch[1], switch[2], 0xB2B2B2, text.trim(switch[3]) or ""))
    newSwitch.state = false
    newSwitch.eventHandler = function(workspace, object, event)
        if event == "touch" then
            -- When switch is clicked, we toggle the switch in the GUI and send the state to the controller
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
    local switchName = newSwitchTbl[5]
    table.insert(SwitchTexts, workspace:addChild(GUI.text(calculatedTextPos.x, calculatedTextPos.y, 0xFFFFFF, switchName)):indexOf())
end

-- Import crossings
for _, crossing in pairs(config.Crossings) do
    -- Create crossing button in layout
    local newcrossing = workspace:addChild(GUI.text(crossing[1], crossing[2], 0xB2B2B2, text.trim(crossing[3]) or ""))
    newcrossing.state = false
    newcrossing.eventHandler = function(workspace, object, event)
        if event == "touch" then
            -- When crossing is clicked, we toggle the crossing in the GUI and send the state to the controller
            object.state = not object.state
            if object.state then
                object.color = 0xFF0000
            else
                object.color = 0xB2B2B2
            end
            object.text = object.state and crossing[4] or crossing[3]
            utils.toggleCrossing(crossing[5])
            workspace:draw()
        end
    end
end

-- Import signals
local signalMenus = {}

local function startPN(signal, signalTbl)
    local t
    t = thread.create(function()
        while true do
            if not (controllers.Signals.getState(signalTbl[3]) == "PN") then t:kill() end
            signal.colors.default.text = 0xFFFFFF
            signal.colors.pressed.text = 0xFFFFFF
            workspace:draw()
            if not (controllers.Signals.getState(signalTbl[3]) == "PN") then t:kill() end
            os.sleep(0.5)
            signal.colors.default.text = 0xB2B2B2
            signal.colors.pressed.text = 0xB2B2B2
            workspace:draw()
            if not (controllers.Signals.getState(signalTbl[3]) == "PN") then t:kill() end
            os.sleep(0.5)
        end
    end):resume()
end

local function setSignalStateGUI(signal, state, signalTbl)
    -- stuj: 0xFF0000
    -- vystraha: 0xFFFF00
    -- volno: 0x008000
    -- posunZak: 0x0000FF
    -- posunDov: 0xFFFFFF
    signal.colors.default.text = 0xB2B2B2
    signal.colors.pressed.text = 0xB2B2B2
    ::signal::
    if state == nil then return end
    if state == "Stuj" then
        signal.colors.default.text = 0xB2B2B2
        signal.colors.pressed.text = 0xB2B2B2
    elseif state == "Vystraha" then
        signal.colors.default.text = 0x00FF00
        signal.colors.pressed.text = 0x00FF00
    elseif state == "Volno" then
        signal.colors.default.text = 0x00FF00
        signal.colors.pressed.text = 0x00FF00
    elseif state == "PosunDov" then
        signal.colors.default.text = 0xFFFFFF
        signal.colors.pressed.text = 0xFFFFFF
    elseif state == "PosunZak" then
        signal.colors.default.text = 0xB2B2B2
        signal.colors.pressed.text = 0xB2B2B2
    elseif state == "PN" then
        startPN(signal, signalTbl)
    elseif string.sub(state, 1, 3) == "R40" or string.sub(state, 1, 3) == "R60" or string.sub(state, 1, 3) == "R80" then
        signal.colors.default.text = 0xFFFF00
        signal.colors.pressed.text = 0xFFFF00
    elseif string.sub(state, 1, 4) == "Opak" then
        state = string.sub(state, 5)
        goto signal
    end
end

for _, signal in pairs(config.Signals) do
    -- Create signal button in layout
    local newSignal = workspace:addChild(GUI.button(signal[1], signal[2], 1, 1, 0x000000, 0xB2B2B2, 0x000000, 0xB2B2B2, signal[4]))
    signalMenus[signal[3]] = false
    newSignal.onTouch = function()
        -- When signal is clicked, we first check if the menu is already open
        if signalMenus[signal[3]] == false then
            -- If not, we create the menu
            signalMenus[signal[3]] = true
            local signalMenu = workspace:addChild(GUI.titledWindow(workspace.width - 30, workspace.height - 25, 30, 25, signal[3], true))
            signalMenu.actionButtons.close.onTouch = function()
                -- When the close button is clicked, we remove the menu and set it's existence to false
                signalMenu:remove()
                signalMenus[signal[3]] = false
                setSignalStateGUI(newSignal, controllers.Signals.getState(signal[3]), signal)
            end

            -- We then add all the possible states to the menu
            for i, state in pairs(controllers.Signals.getValidStatesForSignal(signal[3])) do
                local signalMenuState = signalMenu:addChild(GUI.button(5, i+1, 20, 1, 0x555555, 0x000000, 0x19ED15, 0x000000, state))
                signalMenuState.switchMode = true
                signalMenuState.animated = false
                -- PN state is highlited red (for safety reasons)
                if state == "PN" then signalMenuState.colors.default.text = 0xFC0303 end
                -- We highlight the current state that the signal is in
                if controllers.Signals.getState(signal[3]) == state then
                    signalMenuState.pressed = true
                end
                signalMenuState.onTouch = function()
                    -- When a state is clicked, we check if the signal is a normal signal or an expect signal
                    if not (string.sub(signal[3], 1, 2) == "Pr") then
                        -- If it's a normal signal, we set the state of the signal to the state that was clicked and we send the state to the expect signal
                        for _, signalState in pairs(signalMenu.children) do
                            signalState.pressed = false
                        end
                        signalMenuState.pressed = true
                        controllers.Signals.setState(signal[3], state)
                        utils.sendStateToExpectSig(signal[3], state)
                        setSignalStateGUI(newSignal, state, signal)
                        workspace:draw()
                    else
                        -- If it's an expect signal, we alert the user that the expect signal is controlled automatically
                        signalMenuState.pressed = false
                        if controllers.Signals.getState(signal[3]) == state then
                            signalMenuState.pressed = true
                        end
                        workspace:draw()
                        GUI.alert("Předvěsti jsou ovládány automaticky / Expect signals are controlled automatically")
                    end
                end
            end
            workspace:draw()
        end
    end
    setSignalStateGUI(newSignal, controllers.Signals.getState(signal[3]), signal)

    -- Create signal description
    local newSigTbl = table.clone(signal)
    newSigTbl[3] = string.sub(signal[3], 1, -3)
    local calculatedTextPos = utils.calcSignalTextPos(newSigTbl)
    local sigName = newSigTbl[3]
    table.insert(SignalTexts, workspace:addChild(GUI.text(calculatedTextPos.x, calculatedTextPos.y, 0xFFFFFF, sigName)):indexOf())
end

-- Import labels
for _, label in pairs(config.Labels) do
    workspace:addChild(GUI.button(label[1] - (string.len(label[3]) / 2), label[2], string.len(label[3]) + 2, 1, 0x0000FF, 0xFFFFFF, 0x0000FF, 0xFFFFFF, label[3]))
end

-- Reset layout
utils.resetLayout()

workspace:draw()
workspace:start()
