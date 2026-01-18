local fs = require("@lune/fs")
local roblox = require("@lune/roblox")

print("--- Script Started ---")

if fs.isDir("assets/templates_gen") then
	print("Cleaning up old 'assets/templates_gen' directory...")
	fs.removeDir("assets/templates_gen")
end

fs.writeDir("assets/templates_gen")

-- Read the file
local file = fs.readFile("assets/templates.rbxm")
print("File loaded. Size: " .. #file .. " bytes")

-- deserializeModel returns a TABLE of instances
local instances = roblox.deserializeModel(file)
print("Total root objects found in file: " .. #instances)

-- Search for the "Templates" folder
local templatesFolder = nil
for _, inst in ipairs(instances) do
	if inst.Name == "Templates" then
		templatesFolder = inst
		break
	else
		local found = inst:FindFirstChild("Templates", true)
		if found then
			templatesFolder = found
			break
		end
	end
end

local function process(instance, currentPath)
	local children = instance:GetChildren()
	for _, child in ipairs(children) do
		local path = currentPath .. "/" .. child.Name

		if child.ClassName == "Folder" then
			if not fs.isDir(path) then
				fs.writeDir(path)
			end
			process(child, path)
		else
			local rbxm = roblox.serializeModel({ child })
			fs.writeFile(path .. ".rbxm", rbxm)
			print("Exported: " .. path)
		end
	end
end

if templatesFolder then
	print("✅ Success: 'Templates' folder found. Starting export...")
	process(templatesFolder, "assets/templates_gen")
	print("--- Export Finished ---")
else
	print("❌ ERROR: 'Templates' folder not found!")
	print("Root objects detected in file:")
	for i, v in ipairs(instances) do
		print(string.format("  [%d] Name: '%s', Class: %s", i, v.Name, v.ClassName))
	end
end
