local shell = require("shell")
local fs = require("filesystem")
local repo = "https://raw.githubusercontent.com/Petsox/Open-Rail-Management-System/dev/"
local repoFiles = { "orms.lua", "SaS.lua", "gui.lua", "ormsLib.lua", "updater.lua", "S_1xSingle.lua", "S_2xDualHead.lua", "S_2xDualHead1xSingle.lua", "S_Shunt.lua", "S_Expect.lua", "S_1xDualHead1xSingle.lua" }
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
  shell.execute("wget -f " .. repo .. file)
end

print("Update Complete, rebooting")
os.sleep(2)
shell.execute("reboot")