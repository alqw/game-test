--!strict

local GateAnimation = require("@client/animations/GateAnimation")
local Net = require("@shared/remote/net")

local GateController = {}

local TaskUtil = require("@shared/utils/TaskUtil")

local eventConnection: RBXScriptConnection? = nil

function GateController.Start()
	GateController.Stop()
	GateAnimation.Reset()

	eventConnection = Net.GateOpened.OnClientEvent:Connect(function(gateName)
		GateAnimation.Open(gateName)
	end)
end

function GateController.Stop()
	eventConnection = TaskUtil.Disconnect(eventConnection, script.Name)
end

return GateController
