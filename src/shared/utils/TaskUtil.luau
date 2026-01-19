--!strict

local TaskUtil = {}

function TaskUtil.SafeInit(name: string, initFunc: () -> ())
	task.spawn(function()
		local success, error: any = pcall(initFunc)
		if not success then
			warn(string.format("⚠️ System [%s] failed to load: %s", name, tostring(error)))
		else
			print(string.format("✅ System [%s] started successfully", name))
		end
	end)
end

function TaskUtil.Disconnect(connection: RBXScriptConnection?, scriptName: string): nil
	if connection then
		if connection.Connected then
			connection:Disconnect()
		end

		local name = scriptName or "Unknown Script"
		print(name .. ": Connection cleaned up")
	end
	return nil
end

return TaskUtil
