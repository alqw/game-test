--!strict

local PuzzleStore = require("@shared/state/PuzzleStore")
local Net = require("@shared/remote/net")

local PuzzleLogic = {}
local Config = require("@shared/constants/Config")

local eventConnections: { RBXScriptConnection } = {}

function PuzzleLogic.Start()
	PuzzleLogic.Stop()

	local world = workspace:FindFirstChild("World")
	if not world then
		warn("⚠️ PuzzleLogic: World folder not found!")
		return
	end

	local buttonsFolder = world:FindFirstChild("Buttons")
	if not buttonsFolder then
		warn("⚠️ PuzzleLogic: Buttons folder not found!")
		return
	end

	for i = 1, Config.BUTTON_COUNT do
		local btnName = "Button0" .. i
		local btn = buttonsFolder:FindFirstChild(btnName) :: BasePart

		if not btn then
			warn("⚠️ PuzzleLogic: Missing " .. btnName)
			continue
		end

		local prompt = btn:WaitForChild("ProximityPrompt") :: ProximityPrompt

		if prompt then
			local buttonIndex = i

			local connection = prompt.Triggered:Connect(function(player)
				PuzzleStore.toggleButton(buttonIndex)

				local currentState = PuzzleStore.mainAtom()
				Net.PuzzleUpdate:FireAllClients(currentState, PuzzleStore.getLightsState())
			end)

			table.insert(eventConnections, connection)
		end
	end
end

function PuzzleLogic.Stop()
	for _, connection in ipairs(eventConnections) do
		if connection.Connected then
			connection:Disconnect()
		end
	end
	table.clear(eventConnections)
	print("PuzzleLogic: Buttons disconnected")
end

return PuzzleLogic
