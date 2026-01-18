--!strict

local Charm = require("@pkg/Charm")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GateRemote = ReplicatedStorage:WaitForChild("GateOpened") :: RemoteEvent
local WinRemote = ReplicatedStorage:WaitForChild("ShowWinUI") :: RemoteEvent

local Store = require("@shared/state/Store")
local PuzzleStore = require("@shared/state/PuzzleStore")

local GateLogic = {}

local GATE_THRESHOLD = 20
local coinsGateOpened = false
local puzzleGateOpened = false

function GateLogic.Start()
	Charm.subscribe(Store.mainAtom, function(state)
		if state.coins >= GATE_THRESHOLD and not coinsGateOpened then
			coinsGateOpened = true
			GateRemote:FireAllClients("Gate01")
		end
	end)

	Charm.subscribe(PuzzleStore.getLightsState, function(lights)
		if lights.light1 and lights.light2 and lights.light3 and not puzzleGateOpened then
			puzzleGateOpened = true

			GateRemote:FireAllClients("Gate02")

			local buttons = workspace.World.Buttons:GetDescendants()
			for _, obj in ipairs(buttons) do
				if obj:IsA("ProximityPrompt") then
					obj.Enabled = false
				end
			end
			task.delay(3, function()
				WinRemote:FireAllClients()
			end)
		end
	end)
end

return GateLogic
