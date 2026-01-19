--!strict

local Charm = require("@pkg/Charm")

local Net = require("@shared/remote/net")

local Store = require("@shared/state/Store")
local PuzzleStore = require("@shared/state/PuzzleStore")
local Config = require("@shared/constants/Config")

local GateLogic = {}

local disconnectCoins: (() -> ())? = nil
local disconnectPuzzle: (() -> ())? = nil

local coinsGateOpened = false
local puzzleGateOpened = false

function GateLogic.Start()
	GateLogic.Stop()

	disconnectCoins = Charm.subscribe(Store.mainAtom, function(state)
		if state.coins >= Config.GATE_THRESHOLD and not coinsGateOpened then
			coinsGateOpened = true
			Net.GateOpened:FireAllClients("Gate01")
		end
	end)

	disconnectPuzzle = Charm.subscribe(PuzzleStore.getLightsState, function(lights)
		local allOn = lights.light1 and lights.light2 and lights.light3

		if allOn and not puzzleGateOpened then
			puzzleGateOpened = true
			Net.GateOpened:FireAllClients("Gate02")

			local buttonsFolder = workspace:FindFirstChild("World") and workspace.World:FindFirstChild("Buttons")

			if buttonsFolder then
				for _, obj in ipairs(buttonsFolder:GetDescendants()) do
					if obj:IsA("ProximityPrompt") then
						obj.Enabled = false
					end
				end
			end

			task.delay(3, function()
				if puzzleGateOpened then
					Net.ShowWinUI:FireAllClients()
				end
			end)
		end
	end)
end

function GateLogic.Stop()
	if disconnectCoins then
		disconnectCoins()
		disconnectCoins = nil
	end
	if disconnectPuzzle then
		disconnectPuzzle()
		disconnectPuzzle = nil
	end

	coinsGateOpened = false
	puzzleGateOpened = false

	print("GateLogic: Subscriptions cleared and states reset")
end

return GateLogic
