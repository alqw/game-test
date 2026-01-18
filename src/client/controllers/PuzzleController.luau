--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PuzzleAnimation = require("@client/animations/PuzzleAnimation")
local Remote = ReplicatedStorage:WaitForChild("PuzzleUpdate") :: RemoteEvent

local PuzzleController = {}

function PuzzleController.Start()
	local world = workspace:WaitForChild("World")

	Remote.OnClientEvent:Connect(function(buttonsState, lightsState)
		for i = 1, 3 do
			local btn = world.Buttons:FindFirstChild("Button0" .. i)
			if btn then
				PuzzleAnimation.Animate(btn, buttonsState[i])
			end
		end

		local lights = world.Lights
		PuzzleAnimation.Animate(lights.Light01, lightsState.light1)
		PuzzleAnimation.Animate(lights.Light02, lightsState.light2)
		PuzzleAnimation.Animate(lights.Light03, lightsState.light3)
	end)
end

return PuzzleController
