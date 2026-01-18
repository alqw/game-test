local fs = require("@lune/fs")
local serde = require("@lune/serde")

-- Define file names
local INPUT_FILE = "default.project.json"
local OUTPUT_FILE = "base.project.json"

-- 1. Check if the source file exists
if not fs.isFile(INPUT_FILE) then
	error("Source file " .. INPUT_FILE .. " not found!")
end

-- 2. Read and decode the JSON content into a Lua table
local fileContent = fs.readFile(INPUT_FILE)
local project = serde.decode("json", fileContent)

-- 3. Recursive function to traverse the project tree and update paths
local function updatePaths(node)
	if type(node) ~= "table" then
		return
	end

	for key, value in pairs(node) do
		-- Check if the key is a Rojo path definition
		if key == "$path" and type(value) == "string" then
			-- Replace 'dist' with 'src' only if it's at the start of the string
			node[key] = value:gsub("^dist/", "src/"):gsub("^dist$", "src")
		elseif type(value) == "table" then
			-- Recursively process nested child objects
			updatePaths(value)
		end
	end
end

-- 4. Start the transformation process from the 'tree' root
if project.tree then
	updatePaths(project.tree)
else
	error("Invalid project format: 'tree' object not found.")
end

-- 5. Encode the table back to JSON with pretty-printing (indentation)
local updatedContent = serde.encode("json", project, true)

-- 6. Write the result to the new file
fs.writeFile(OUTPUT_FILE, updatedContent)

print("Process complete: '" .. OUTPUT_FILE .. "' has been generated.")
