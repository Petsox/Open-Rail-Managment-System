local shell = require("shell")
local fs = require("filesystem")
local repoFiles = {
	{file = "init.lua",                 link = "Bq7r7ax1"},
	{file = "json.lua",                 link = "S1xp1yvg"},
	{file = "config.lua",               link = "MCQNRBnh"},
	{file = "controllers.lua",          link = "Pu7xWjGb"},
	{file = "utils.lua",                link = "pHwREF5r"},
	{file = "grapes/Color.lua",         link = "gqNHhdEQ"},
	{file = "grapes/Event.lua",         link = "yTNKPyDX"},
	{file = "grapes/Filesystem.lua",    link = "KnKzuAeK"},
	{file = "grapes/GUI.lua",           link = "PMkQCUVc"},
	{file = "grapes/Image.lua",         link = "njzs2te0"},
	{file = "grapes/Keyboard.lua",      link = "jy6YNds6"},
	{file = "grapes/Number.lua",        link = "dYHbSf9i"},
	{file = "grapes/Paths.lua",         link = "9w5zsW1A"},
	{file = "grapes/Screen.lua",        link = "vnhPgFNE"},
	{file = "grapes/Text.lua",          link = "wTyBUqw7"},
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
for _, data in pairs(repoFiles) do
  if fs.exists(installLoc .. data.file) and not OverwriteAll then
    print("File " .. data.file .. " already exists. Overwrite? (Y - Yes/N - No/A - All)")
    ::OverwriteFile::
    local input = string.lower(io.read())
    if input ~= "n" and input ~= "y" and input ~= "a" then
      print("Invalid choice (Y/N/A)")
      goto OverwriteFile
    end

    if input == "a" then
      OverwriteAll = true
      shell.execute("pastebin get -f " .. data.link .. " " .. data.file)
    end

    if input == "y" then
      shell.execute("pastebin get -f " .. data.link .. " " .. data.file)
    end
  else
    shell.execute("pastebin get -f " .. data.link .. " " .. data.file)
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
