local process = require("@lune/process")
local fs = require("@lune/fs")

print("--- Starting Simple Build ---")

-- 1. Refresh the bin directory
if fs.isDir("bin") then
	print("Cleaning up old 'bin' folder...")
	fs.removeDir("bin")
end

fs.writeDir("bin")
print("Created fresh 'bin' directory.")

-- 2. Run Rojo Build
print("Building Game.rbxl...")

local buildRes = process.exec("rojo", {
	"build",
	"default.project.json",
	"--output",
	"bin/Game.rbxl",
})

-- 3. Check results
if buildRes.code == 0 then
	print("\n✅ Done! File saved to: bin/Game.rbxl")
else
	print("\n❌ Build failed:")
	print(buildRes.stderr)
end
