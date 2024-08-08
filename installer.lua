local shell = require("shell")
local fs = require("filesystem")
local repo = "https://raw.githubusercontent.com/Petsox/Open-Rail-Management-System/new-master/"
local repoFiles = { "init.lua", "json.lua", "config.lua", "controllers.lua", "updater.lua", "utils.lua", "grapes/Color.lua", "grapes/Event.lua", "grapes/Filesystem.lua", "grapes/GUI.lua", "grapes/Image.lua", "grapes/Keyboard.lua", "grapes/Number.lua", "grapes/Paths.lua", "grapes/Screen.lua", "grapes/Text.lua" }
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

if not fs.isDirectory(installLoc .. "grapes") then
  fs.makeDirectory(installLoc .. "grapes")
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
      shell.execute("wget -f " .. repo .. file .. " -O " .. file)
    end

    if input == "y" then
      shell.execute("wget -f " .. repo .. file .. " -O " .. file)
    end
  else
    shell.execute("wget -f " .. repo .. file .. " -O " .. file)
  end
end

shell.execute("wget -f " .. repo .. "launcher.lua" .. " -O " .. "/bin/orms.lua")

print("Add to startup? (Y - Yes/N - No)")
::AddToStartup::
local input = string.lower(io.read())
if input ~= "n" and input ~= "y" then
  print("Invalid choice (Y/N)")
  goto AddToStartup
end
if input == "y" then
    io.open("/home/.shrc", "a"):write("orms.lua\n"):close()
end

print("Install Complete")
