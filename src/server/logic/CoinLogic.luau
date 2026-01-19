--!strict

local Players = game:GetService("Players")
local Store = require("@shared/state/Store")

local CoinsFolder = workspace:WaitForChild("World"):WaitForChild("Coins")
local Net = require("@shared/remote/net")

local CoinLogic = {}

local eventConnections: { [BasePart]: RBXScriptConnection } = {}

function CoinLogic.Start()
	CoinLogic.Stop()

	for _, coin in ipairs(CoinsFolder:GetChildren()) do
		if not coin:IsA("BasePart") then
			continue
		end

		eventConnections[coin] = coin.Touched:Connect(function(otherPart)
			local player = Players:GetPlayerFromCharacter(otherPart.Parent)

			if player and coin.CanTouch then
				coin.CanTouch = false
				coin.Transparency = 1

				Store.addCoins(1)
				Net.CoinCollected:FireAllClients(coin)

				task.delay(1, function()
					if eventConnections[coin] then
						eventConnections[coin]:Disconnect()
						eventConnections[coin] = nil
					end
					coin:Destroy()
				end)
			end
		end)
	end
end

function CoinLogic.Stop()
	for part, connection in pairs(eventConnections) do
		if connection.Connected then
			connection:Disconnect()
		end
	end
	table.clear(eventConnections)
	print("CoinLogic: Server cleanup done")
end

return CoinLogic
