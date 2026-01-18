--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remote = ReplicatedStorage:WaitForChild("CoinCollected") :: RemoteEvent

local Store = require("@shared/state/Store")
local CoinAnimation = require("@client/animations/CoinAnimation")

local CoinController = {}

function CoinController.Start()
	Remote.OnClientEvent:Connect(function(coinPart: BasePart)
		if coinPart and coinPart.Parent then
			Store.addCoins(1)
			CoinAnimation.PlayCollectEffect(coinPart)
		end
	end)
end

return CoinController
