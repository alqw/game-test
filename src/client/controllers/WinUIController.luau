--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIStore = require("@shared/state/UIStore")
local Remote = ReplicatedStorage:WaitForChild("ShowWinUI") :: RemoteEvent

local WinUIController = {}

function WinUIController.Start()
	Remote.OnClientEvent:Connect(function()
		UIStore.setWinVisible(true)
	end)
end

return WinUIController
