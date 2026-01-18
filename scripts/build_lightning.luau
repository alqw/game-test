local fs = require("@lune/fs")
local roblox = require("@lune/roblox")

print("--- Script Started ---")

local TARGET_DIR = "assets/lightning_gen"

-- Clean up and recreate the target directory
if fs.isDir(TARGET_DIR) then
	print("Cleaning up old directory...")
	fs.removeDir(TARGET_DIR)
end
fs.writeDir(TARGET_DIR)

-- Load the .rbxm file
local file = fs.readFile("assets/lightning.rbxm")
-- deserializeModel returns a table of the top-level objects in the file
local instances = roblox.deserializeModel(file)
print("File loaded. Root objects found: " .. #instances)

-- Function to save an instance and recursively handle folders
local function exportInstance(instance, currentPath)
	local path = currentPath .. "/" .. instance.Name

	if instance.ClassName == "Folder" then
		-- If it's a folder, create directory and process its children
		if not fs.isDir(path) then
			fs.writeDir(path)
		end
		for _, child in ipairs(instance:GetChildren()) do
			exportInstance(child, path)
		end
	else
		-- If it's an object (Sky, Bloom, etc.), serialize and save it
		local rbxm = roblox.serializeModel({ instance })
		fs.writeFile(path .. ".rbxm", rbxm)
		print("Exported: " .. path .. ".rbxm")
	end
end

-- Since your file has objects at the root, iterate through the instances table directly
if #instances > 0 then
	print("✅ Objects detected at root. Starting export...")
	for _, inst in ipairs(instances) do
		exportInstance(inst, TARGET_DIR)
	end
	print("--- Export Finished ---")
else
	print("❌ ERROR: The rbxm file appears to be empty!")
end
