local shell = require("shell")
local fs = require("filesystem")
local repo = "https://raw.githubusercontent.com/Petsox/Open-Rail-Management-System/dev/"
local repoFiles = { "orms.lua", "SaS.lua", "gui.lua", "ormsLib.lua", "updater.lua", "station.lua", "S_1xSingle.lua", "S_2xDualHead.lua", "S_2xDualHead1xSingle.lua", "S_Shunt.lua", "controllers.lua", "S_Expect.lua", "S_1xDualHead1xSingle.lua" }
local installLoc = "/home/orms/"

if not fs.isDirectory(installLoc) then
  fs.makeDirectory(installLoc)
end

shell.setWorkingDirectory(installLoc)

for file, _ in fs.list(installLoc) do
  print("Install location contains files within, wipe all? (Y - Yes/N - No)")
  ::WipeInstDir::
  local input = string.lower(io.read())
  if input ~= "n" and input ~= "y" then
    print("Invalid choice (Y/N)")
    goto WipeInstDir
  end

  if input == "y" then
    for file, _ in fs.list(installLoc) do
      fs.remove(installLoc .. file)
    end
  end
  break
end

local OverwriteAll = false
for _, file in pairs(repoFiles) do
  if fs.exists(installLoc .. file) and not OverwriteAll then
    print("File " .. file .. " already exists. Overwrite? (Y - Yes/N - No/A - All)")
    ::OverwriteFile::
    local input = string.lower(io.read())
    if input ~= "n" and input ~= "y" and input ~= "a" then
      print("Invalid choice (Y/N/A)")
      goto OverwriteFile
    end

    if input == "a" then
      OverwriteAll = true
      shell.execute("wget -f " .. repo .. file)
    end

    if input == "y" then
      shell.execute("wget -f " .. repo .. file)
    end
  else
    shell.execute("wget -f " .. repo .. file)
  end
end

print("Install Complete")
