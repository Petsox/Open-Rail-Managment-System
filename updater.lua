local shell = require("shell")
local fs = require("filesystem")
local repo = "https://raw.githubusercontent.com/Petsox/Open-Rail-Management-System/new-master/"
local repoFiles = { "init.lua", "json.lua", "controllers.lua", "updater.lua", "utils.lua", "grapes/Color.lua", "grapes/Event.lua", "grapes/Filesystem.lua", "grapes/GUI.lua", "grapes/Image.lua", "grapes/Keyboard.lua", "grapes/Number.lua", "grapes/Paths.lua", "grapes/Screen.lua", "grapes/Text.lua" }
local installLoc = "/home/orms/"

shell.setWorkingDirectory(installLoc)

for file, _ in fs.list(installLoc) do
  print("Are you sure you want to update ORMS?\nThis will NOT delete your station configuration. (Y - Continue/N - Cancel)")
  ::Update::
  local input = string.lower(io.read())
  if input ~= "n" and input ~= "y" then
    print("Invalid choice (Y/N)")
    goto Update
  end

  if input == "n" then
    print("Update won't be installed")
    os.exit()
  end
  break
end

for _, file in pairs(repoFiles) do
  shell.execute("wget -f " .. repo .. file .. " -O " .. file)
end

print("Update Complete, rebooting")
os.sleep(2)
shell.execute("reboot")