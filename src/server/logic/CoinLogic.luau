--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Store = require("@shared/state/Store")

local CoinsFolder = workspace:WaitForChild("World"):WaitForChild("Coins")
local Remote = ReplicatedStorage:WaitForChild("CoinCollected") :: RemoteEvent

local CoinLogic = {}

function CoinLogic.Start()
	for _, coin in ipairs(CoinsFolder:GetChildren()) do
		if not coin:IsA("BasePart") then
			continue
		end

		coin.Touched:Connect(function(otherPart)
			local player = Players:GetPlayerFromCharacter(otherPart.Parent)

			if player and coin.CanTouch then
				coin.CanTouch = false
				coin.Transparency = 1

				Store.addCoins(1)

				Remote:FireAllClients(coin)

				task.wait(1)
				coin:Destroy()
			end
		end)
	end
end

return CoinLogic
