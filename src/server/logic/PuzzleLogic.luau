--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PuzzleStore = require("@shared/state/PuzzleStore")
local Remote = ReplicatedStorage:WaitForChild("PuzzleUpdate") :: RemoteEvent

local PuzzleLogic = {}

function PuzzleLogic.Start()
	local buttonsFolder = workspace:WaitForChild("World"):WaitForChild("Buttons")

	for i = 1, 3 do
		local btn = buttonsFolder:FindFirstChild("Button0" .. i) :: BasePart
		local prompt = btn:WaitForChild("ProximityPrompt") :: ProximityPrompt

		if prompt then
			prompt.Triggered:Connect(function(player)
				PuzzleStore.toggleButton(i)

				Remote:FireAllClients(PuzzleStore.mainAtom().buttons, PuzzleStore.getLightsState())
			end)
		end
	end
end

return PuzzleLogic
