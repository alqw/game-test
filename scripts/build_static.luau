local fs = require("@lune/fs")
local roblox = require("@lune/roblox")

print("--- Script Started ---")

if fs.isDir("assets/static_gen") then
	print("Cleaning up old 'assets/static_gen' directory...")
	fs.removeDir("assets/static_gen")
end

fs.writeDir("assets/static_gen")

-- Read the file
local file = fs.readFile("assets/static.rbxm")
print("File loaded. Size: " .. #file .. " bytes")

-- deserializeModel returns a TABLE of instances
local instances = roblox.deserializeModel(file)
print("Total root objects found in file: " .. #instances)

-- Search for the "World" folder
local worldFolder = nil
for _, inst in ipairs(instances) do
	if inst.Name == "World" then
		worldFolder = inst
		break
	else
		local found = inst:FindFirstChild("World", true)
		if found then
			worldFolder = found
			break
		end
	end
end

local function process(instance, currentPath)
	local children = instance:GetChildren()

	local totalCounts = {}
	for _, child in ipairs(children) do
		totalCounts[child.Name] = (totalCounts[child.Name] or 0) + 1
	end

	local currentCounts = {}
	for _, child in ipairs(children) do
		local name = child.Name
		local finalName = name

		if totalCounts[name] > 1 then
			currentCounts[name] = (currentCounts[name] or 0) + 1
			finalName = string.format("%s%02d", name, currentCounts[name])
		end

		local path = currentPath .. "/" .. finalName

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

if worldFolder then
	print("✅ Success: 'World' folder found. Starting export...")
	process(worldFolder, "assets/static_gen")
	print("--- Export Finished ---")
else
	print("❌ ERROR: 'World' folder not found!")
	print("Root objects detected in file:")
	for i, v in ipairs(instances) do
		print(string.format("  [%d] Name: '%s', Class: %s", i, v.Name, v.ClassName))
	end
end
