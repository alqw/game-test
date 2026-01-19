--!strict

local Net = require("@shared/remote/net/")

local TaskUtil = require("@shared/utils/TaskUtil")

local Store = require("@shared/state/Store")
local CoinAnimation = require("@client/animations/CoinAnimation")

local CoinController = {}

local eventConnection: RBXScriptConnection? = nil

function CoinController.Start()
	CoinController.Stop()

	eventConnection = Net.CoinCollected.OnClientEvent:Connect(function(coinPart: BasePart)
		if coinPart and coinPart.Parent then
			Store.addCoins(1)
			CoinAnimation.PlayCollectEffect(coinPart)
		end
	end)
end

function CoinController.Stop()
	eventConnection = TaskUtil.Disconnect(eventConnection, script.Name)
end

return CoinController
