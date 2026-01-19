--!strict

local UIStore = require("@shared/state/UIStore")
local Net = require("@shared/remote/net")

local WinUIController = {}

local TaskUtil = require("@shared/utils/TaskUtil")

local eventConnection: RBXScriptConnection? = nil

function WinUIController.Start()
	WinUIController.Stop()

	eventConnection = Net.ShowWinUI.OnClientEvent:Connect(function()
		UIStore.setWinVisible(true)
	end)
end

function WinUIController.Stop()
	eventConnection = TaskUtil.Disconnect(eventConnection, script.Name)
end

return WinUIController
