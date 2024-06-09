local gui = require("gui")
local SaS = require("SaS")
local ormslib = {}

local signalRunning = false
local signalValue = false
local signalID = ""
local signalName = ""

local function Cancel()
  signalRunning = false
  signalValue = true
end

--Signals

local function ChangeState(state)
  SaS.ChangeState(signalName, state)
  Cancel()
  gui.setSignal(mainGui, signalID, 0x00FF00, true)

  local predvest = gui.getSignal(mainGui, "Pr" .. signalName)
  if predvest == -1 then return end
  gui.setSignal(mainGui, predvest, 0x00FF00, true)
end


--Jednosvětelný

function ormslib.SignalOne(name, widgetID)
  signal1Gui = gui.newGui(111, 27, 40, 10, true, "Návěst " .. name)
  signalCancelButton = gui.newButton(signal1Gui, 3, 8, "Zrušit", Cancel)
  signalStujButton = gui.newButton(signal1Gui, 3, 3, "Návěst na Stůj", Stuj)
  signalVystrahaButton = gui.newButton(signal1Gui, 3, 4, "Návěst na Výstraha", Vystraha)
  signalVolnoButton = gui.newButton(signal1Gui, 3, 5, "Návěst na Volno", Volno)

  signalID = widgetID
  signalName = name
  signalRunning = true
  gui.displayGui(signal1Gui)
  while signalRunning == true do
    gui.runGui(signal1Gui)
  end
  gui.closeGui(signal1Gui)
  return signalValue
end


--Switches

function ormslib.Switch(guiID, widgetID, name)
  if mainGui[widgetID].from == mainGui[widgetID].text then
    SaS.switchTo(mainGui[widgetID].name)
    gui.setText(mainGui, widgetID, mainGui[widgetID].to, true)
  else
    SaS.switchFrom(mainGui[widgetID].name)
    gui.setText(mainGui, widgetID, mainGui[widgetID].from, true)
  end
end

return ormslib
