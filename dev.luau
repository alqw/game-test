local process = require("@lune/process")
local fs = require("@lune/fs")
local task = require("@lune/task")

print("Preparing dist...")

if fs.isDir("dist") then
	fs.removeDir("dist")
end
fs.writeDir("dist")

print("Slicing assets...")

-- Start build_static
print("> Running build_static.luau")
local staticRes = process.exec("lune", { "run", "scripts/build_static.luau" })
if #staticRes.stdout > 0 then
	print(staticRes.stdout)
end
if staticRes.code ~= 0 then
	print("Error in build_static. Code: " .. staticRes.code)
	print("Stderr: " .. staticRes.stderr)
end

-- Start build_templates
print("> Running build_templates.luau")
local templatesRes = process.exec("lune", { "run", "scripts/build_templates.luau" })
if #templatesRes.stdout > 0 then
	print(templatesRes.stdout)
end
if templatesRes.code ~= 0 then
	print("Error in build_templates. Code: " .. templatesRes.code)
	print("Stderr: " .. templatesRes.stderr)
end

print("Processing with Darklua...")
process.exec("rojo", { "sourcemap", "base.project.json", "--output", "sourcemap.json" })

local convertRes = process.exec("lune", { "run", "scripts/convert.luau" })
if #convertRes.stdout > 0 then
	print(convertRes.stdout)
end
if convertRes.code ~= 0 then
	print("Error in convert. Code: " .. convertRes.code)
	print("Stderr: " .. convertRes.stderr)
end

task.spawn(function()
	local darkluaRes = process.exec("darklua", { "process", "src", "dist", "--watch" })
	if darkluaRes.code ~= 0 then
		print("Darklua error: " .. darkluaRes.stderr)
	end
end)

task.wait(1)

print("Assets ready!\n")
print("Running Rojo...")

process.exec("rojo", { "serve" }, {
	stdio = "inherit",
})
