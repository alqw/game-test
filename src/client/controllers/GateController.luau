--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GateAnimation = require("@client/animations/GateAnimation")
local Remote = ReplicatedStorage:WaitForChild("GateOpened") :: RemoteEvent

local GateController = {}

function GateController.Start()
	Remote.OnClientEvent:Connect(function(gateName)
		GateAnimation.Open(gateName)
	end)
end

return GateController
