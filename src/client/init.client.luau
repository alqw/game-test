--!strict

local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")

local TaskUtil = require("@shared/utils/TaskUtil")

local Players = game:GetService("Players")

local uiRoot: any = nil

local function main()
	TaskUtil.SafeInit("InitUI", InitUI)
	InitAnimations()
	InitControllers()
end

function InitUI()
	local HUDGui = require("@client/ui/HUDGui")
	local WinGui = require("@client/ui/WinGui")

	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	if uiRoot then
		uiRoot:unmount()
		uiRoot = nil
	end

	uiRoot = ReactRoblox.createRoot(playerGui)
	uiRoot:render(React.createElement(React.Fragment, {}, {
		HUD = React.createElement(HUDGui),
		Win = React.createElement(WinGui),
	}))
end

function InitAnimations()
	local CoinAnimation = require("@client/animations/CoinAnimation")

	TaskUtil.SafeInit("CoinAnimation", CoinAnimation.Start)
end

function InitControllers()
	local CoinController = require("@client/controllers/CoinController")
	local GateController = require("@client/controllers/GateController")
	local PuzzleController = require("@client/controllers/PuzzleController")
	local WinUIController = require("@client/controllers/WinUIController")

	TaskUtil.SafeInit("CoinController", CoinController.Start)
	TaskUtil.SafeInit("GateController", GateController.Start)
	TaskUtil.SafeInit("PuzzleController", PuzzleController.Start)
	TaskUtil.SafeInit("WinUIController", WinUIController.Start)
end

main()
