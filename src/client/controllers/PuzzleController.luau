--!strict
local PuzzleAnimation = require("@client/animations/PuzzleAnimation")
local Net = require("@shared/remote/net")

local PuzzleController = {}

local TaskUtil = require("@shared/utils/TaskUtil")
local Config = require("@shared/constants/Config")

local eventConnection: RBXScriptConnection? = nil

function PuzzleController.Start()
	PuzzleController.Stop()
	PuzzleAnimation.Reset()

	local world = workspace:WaitForChild("World")
	local buttonsFolder = world:WaitForChild("Buttons")

	eventConnection = Net.PuzzleUpdate.OnClientEvent:Connect(function(state, lightsState)
		for i = 1, Config.BUTTON_COUNT do
			local btn = buttonsFolder:FindFirstChild("Button0" .. i)
			if btn then
				PuzzleAnimation.Animate(btn, state.buttons[i])
			end
		end

		local lightsFolder = world.Lights
		for i = 1, Config.LIGHT_COUNT do
			local lightName = "Light0" .. i
			local lightPart = lightsFolder:FindFirstChild(lightName)

			if lightPart then
				local isOn = lightsState["light" .. i] == true
				PuzzleAnimation.Animate(lightPart, isOn)
			end
		end
	end)
end

function PuzzleController.Stop()
	eventConnection = TaskUtil.Disconnect(eventConnection, script.Name)
end

return PuzzleController
