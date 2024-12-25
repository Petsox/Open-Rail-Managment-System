local shell = require("shell")
local fs = require("filesystem")
local repoFiles = { 
	"init.lua" = "Bq7r7ax1", 
	"json.lua" = "S1xp1yvg", 
	"config.lua" = "MCQNRBnh", 
	"controllers.lua" = "Pu7xWjGb",
	"utils.lua" = "pHwREF5r", 
	"grapes/Color.lua" = "gqNHhdEQ", 
	"grapes/Event.lua" = "yTNKPyDX", 
	"grapes/Filesystem.lua" = "KnKzuAeK", 
	"grapes/GUI.lua" = "PMkQCUVc", 
	"grapes/Image.lua" = "njzs2te0", 
	"grapes/Keyboard.lua" = "jy6YNds6", 
	"grapes/Number.lua" = "dYHbSf9i", 
	"grapes/Paths.lua" = "9w5zsW1A", 
	"grapes/Screen.lua" = "vnhPgFNE", 
	"grapes/Text.lua" = "wTyBUqw7", 
}
local launcherId = "n9bSKZ96"
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
for file, id in pairs(repoFiles) do
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
      shell.execute("pastebin get -f " .. id .. " " .. file)
    end

    if input == "y" then
      shell.execute("pastebin get -f " .. id .. " " .. file)
    end
  else
    shell.execute("pastebin get -f " .. id .. " " .. file)
  end
end

-- Launcher
shell.execute("pastebin get -f " .. launcherId .. " " .. "/bin/orms.lua")

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
